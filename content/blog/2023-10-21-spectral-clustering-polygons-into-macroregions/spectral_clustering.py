#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 21 13:35:44 2023

@author: bas
"""

import geopandas as gpd
import numpy as np
from sklearn.cluster import SpectralClustering
import matplotlib.pyplot as plt

# Retrieve data with municipal boundaries
gdf = gpd.read_file('nl_2020.geojson')

# Fix invalid geometries
gdf['geometry'] = gdf['geometry'].buffer(0)

# Calculate pairwise similarity based on the spatial relationship
similarity_matrix = np.zeros((len(gdf), len(gdf)))

for i in range(len(gdf)):
    for j in range(len(gdf)):
        if i == j:
            similarity_matrix[i][j] = 1
        if i != j:
            # Adjust the similarity matrix entries
            if gdf.iloc[i].geometry.touches(gdf.iloc[j].geometry):
                similarity_matrix[i][j] = 1

# Create an affinity matrix
row_sums = similarity_matrix.sum(axis=1)
normalized_matrix = similarity_matrix / row_sums[:, np.newaxis]


# Perform spectral clustering using the customized affinity matrix
n_clusters = 10  # Number of macro polygons
clustering = SpectralClustering(n_clusters=n_clusters, affinity='precomputed', assign_labels='discretize').fit(normalized_matrix)

# Create a new GeoDataFrame to store macro polygons
macro_polygons = gpd.GeoDataFrame(geometry=[])

# Iterate through the clusters
for cluster_id in range(n_clusters):
    # Extract polygons in the current cluster
    cluster_mask = (clustering.labels_ == cluster_id)
    cluster_gdf = gdf[cluster_mask]
    
    if len(cluster_gdf) > 0:
        # Merge polygons within the cluster
        merged_polygon = cluster_gdf.unary_union  # Merge all geometries in the cluster

        # Add the merged polygon to the GeoDataFrame
        macro_polygons = macro_polygons.append({'geometry': merged_polygon}, ignore_index=True)

# Define a colormap with distinct colors
colors = ['red', 'blue', 'green', 'purple', 'yellow', 'black', 'cyan', 'gold', 'magenta', 'brown', 'orange', 'grey']  # Add more colors as needed

# Create a figure with two subplots
fig, axs = plt.subplots(1, 2, figsize=(12, 6))

# Plot the original polygons on the left subplot
gdf.plot(ax=axs[0], color='blue', edgecolor='black')
axs[0].set_title('Original Polygons')

# Plot the macro polygons on the right subplot with different colors for each cluster
for cluster_id in range(n_clusters):
    cluster_color = colors[cluster_id]
    macro_polygons[macro_polygons.index == cluster_id].plot(ax=axs[1], color=cluster_color, label=f'Cluster {cluster_id}')

axs[1].set_title('Macro Polygons')
#axs[1].legend(loc='upper right')

# Adjust plot settings
for ax in axs:
    ax.axis('off')

# Show the plots side by side
plt.tight_layout()
plt.savefig('side_by_side_plot.png', dpi=300)  # Specify the file name and format

plt.show()
