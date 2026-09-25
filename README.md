# Western Ghats Presence Location Tool

An interactive Shiny application for approximating species observation locations across the Western Ghats using a standardized square grid.

**Live application:**
https://nilgirimartenproject.shinyapps.io/grid

## About

Species observations are often obtained through anecdotal reports, personal communications, and other informal sources where an exact geographic coordinate may not be available. This tool provides a simple and consistent way to record the approximate location of such observations across the Western Ghats.

The application allows users to select a state and district, locate the approximate observation site on an interactive map, and identify the unique ID of the grid cell containing the observation.

The resulting grid ID can be used to communicate an approximate species location and to associate the observation with environmental data for subsequent spatial analyses, including species distribution modelling.

## Grid

The Western Ghats region is divided into a regular square grid, with each cell assigned a unique `cell_id`.

The grid was generated in R using the `create_fishnet()` function from the **sprawl** package. The dimensions of the grid cells correspond exactly to the spatial dimensions of pixels in the **30 arc-second resolution WorldClim v2.1** bioclimatic datasets.

This provides a standardized spatial framework for compiling occurrence information from different sources while maintaining compatibility with environmental datasets commonly used in species distribution modelling.

The grid provided in this repository is:

`fishnet_wgclip`

## Using the application

The live application can be accessed here:

https://nilgirimartenproject.shinyapps.io/grid

Users can:

1. Select the state where the observation was made.
2. Select the district.
3. Zoom and navigate the map to identify the approximate observation location.
4. Tap a grid cell on a phone or tablet, or hover over a grid cell on a computer, to view its `cell_id`.
5. Use the `cell_id` to communicate the approximate location of the observation.

The map can be viewed using either OpenStreetMap or satellite imagery.

## Running the application locally

The application is written in R using Shiny.

### Requirements

The following R packages are required:

```r
install.packages(c(
  "shiny",
  "leaflet",
  "sf",
  "dplyr"
))
```

### Files required

The application requires:

* `app.R`
* `WG_Districts.shp`
* `WG_Districts.dbf`
* `WG_Districts.shx`
* `WG_Districts.prj`
* `fishnet_wgclip.shp`
* `fishnet_wgclip.dbf`
* `fishnet_wgclip.shx`
* `fishnet_wgclip.prj`

The `WG_Districts` files are required for the application interface but are **not included in this repository**. Users wishing to run the application locally will need to obtain the corresponding district boundary dataset from the original source.

To run the application:

```r
shiny::runApp()
```

## Data sources

### Western Ghats boundary

The spatial extent of the tool is based on the Western Ghats region defined in:

CEPF. 2007. *Western Ghats Ecosystem Profile.*

[Western Ghats Ecosystem Profile (PDF)](https://www.cepf.net/sites/default/files/western-ghats-ecosystem-profile-english.pdf)

### District boundaries

District boundaries used by the application are from **Survey of India (SOI)**.

The district boundary data are not redistributed in this repository.

### Environmental data resolution

The grid dimensions correspond to the **30 arc-second resolution** of the WorldClim v2.1 bioclimatic datasets.

WorldClim: https://www.worldclim.org/

### Grid generation

The grid was generated in R using the `create_fishnet()` function from the **sprawl** package.

## Repository contents

```text
Western-Ghats-Presence-Location-Tool/
│
├── app.R
├── CITATION.cff
├── LICENSE
├── README.md
│
├── fishnet_wgclip.shp
├── fishnet_wgclip.shx
├── fishnet_wgclip.dbf
└── fishnet_wgclip.prj
```

## Citation

If you use this tool or the associated grid in a publication, please cite:

> Nazareth, O. (2026). *Western Ghats Presence Location Tool* [Shiny web application]. GitHub.

The repository contains a `CITATION.cff` file, which provides machine-readable citation information and allows GitHub to generate citation formats through the **Cite this repository** option.

## License

The source code of this project is released under the **MIT License**.

Please note that external datasets referenced by the application, including district boundary data and the sources used to define the Western Ghats extent, are not covered by this license and remain subject to their respective terms of use.

## Contact

For the grid shapefile or queries regarding the tool:

**Nazareth Orvill**
[nazareth.orvill@gmail.com](mailto:nazareth.orvill@gmail.com)
