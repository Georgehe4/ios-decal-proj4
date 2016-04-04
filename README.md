# ios-decal-proj4

# GrepIRL


## Authors
* George He [@georgehe4]

* Susanna Souv [@susannasouv]

## Purpose
GrepIRL exists to help people find useful resources such as power outlets,
restrooms, and meeting areas.

## Features
* Rating 
* Geotagging
* Photos
* Multi-user [Server information]
* Categories/Tags on items
* Mapping of items

## Control Flow
* Open app
* List view of items nearby
   * Optional map view of items
* Tap on an item to open it (information about reviews, pictures, etc)
* Option to add review/add item
    * Tag/classify/rate/pictures

## Implementation

### Model
* Rating.swift
    * ID to item
    * 1~5 rating
    * Description
    * Optional picture
    * Rating helpfulness 

* Item.swift
    * Geolocation of item
    * Description of item
    * Tags of item

### View
* RatingListTableView
* RatingMapView
* AddRatingView
* SingleRatingView
* ItemSummaryView

### Controller
* RatingListTableViewController
* RatingMapViewController
* AddRatingViewController
* SingleRatingViewController
* ItemSummaryViewController