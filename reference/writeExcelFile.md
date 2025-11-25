# Write Data Frames to Excel File

Writes a named list of data frames to an Excel file, with optional meta
information. Each list element becomes a separate sheet in the output
file.

## Usage

``` r
writeExcelFile(
  sheetList,
  file,
  ...,
  addMetaInformationSheet = TRUE,
  userName = "Anonymous"
)
```

## Arguments

- sheetList:

  A named list of data frames; each name represents the sheet name.

- file:

  Character string specifying the output Excel file path.

- ...:

  Additional arguments (currently not used).

- addMetaInformationSheet:

  Logical; if `TRUE`, adds a meta information sheet. Default is `TRUE`.

- userName:

  Character string for the user name in meta information. Default is
  `"Anonymous"`.

## Value

The file path of the written Excel file.
