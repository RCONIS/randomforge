# Randomization with Flexible Block Sizes with randomforge

## Introduction

This vignette provides a practical example for **randomforge**. It
demonstrates:

- How to define treatment arms  
- How to configure project-level randomization  
- How do you implement permuted block randomization (PBR) with a fixed
  starting block size and continuation with variable block sizes
- How to perform quality control of random values  
- How to extract and inspect the generated randomization list

## Loading the randomforge Package

``` r
library(randomforge)
#> randomforge developer version 0.1.0.9046 loaded
```

## Trial Setup

### Treatment Arms

``` r
treatmentArmIds = c("Treatment", "Control")
```

### Maximum Number of Subjects per Center

``` r
maxNumberOfSubjects <- 40
```

### Seed

The seeds in this example will be generated via  
[random.org](https://www.random.org/)

``` r
seed <- createSeed()
seed
```

    #> [1] 1379678

## Creating Project and Configuration

``` r
randomDataBase <- getRandomDataBase()

randomProject <- getRandomProject(name = "Flexible PBR Example Trial")
randomDataBase$persist(randomProject)

randomConfiguration <- getRandomConfiguration(
    randomProject = randomProject, 
    treatmentArmIds = treatmentArmIds, 
    seed = seed
)
randomDataBase$persist(randomConfiguration)

ravService <- getRandomAllocationValueService()
```

## Initial Randomization Using Fixed Block Size

### Define Initial Block Length

``` r
initialBlockLength <- 8
randomMethod <- getRandomMethodPBR(
    blockSizes = getBlockSizes(treatmentArmIds, initialBlockLength)
)
for (i in 1:initialBlockLength) {
    suppressMessages(getNextRandomResult(
        randomDataBase, randomProject, randomMethod, ravService
    ))
}
```

## Variable Block Sizes for Remaining Subjects

### Define Candidate Block Sizes

``` r
blockSizes <- getBlockSizes(treatmentArmIds, c(4, 6))
blockSizeRandomizer <- getRandomBlockSizeRandomizer(
    blockSizes = blockSizes,
    seed = 2758500)
blockSizeRandomizer$initRandomValues(numberOfBlockSizes = length(blockSizes))
```

### Randomize Remaining Subjects

``` r
randomMethod <- getRandomMethodPBR(
    blockSizes = blockSizes, 
    fixedBlockDesignEnabled = FALSE, 
    blockSizeRandomizer = blockSizeRandomizer
)

for (i in 1:(maxNumberOfSubjects - initialBlockLength)) {
    suppressMessages(getNextRandomResult(
        randomDataBase, randomProject, randomMethod, ravService
    ))
}
```

## Quality Control

### Distribution of Used Random Values

``` r
plot(ravService)
```

![](randomforge_flexible_pbr_example_files/figure-html/unnamed-chunk-11-1.png)

No significant deviation from a uniform distribution is detected (p \>
0.05).

### Distribution of All Generated Random Values

``` r
plot(ravService, usedValuesOnly = FALSE)
```

![](randomforge_flexible_pbr_example_files/figure-html/unnamed-chunk-12-1.png)

## Output: Randomization List

``` r
randomList <- as.data.frame(randomDataBase)
knitr::kable(randomList)
```

| project                    | random-number | treatment-arm | status     | overall-levels-Treatment | overall-levels-Control | block-wise-levels-Treatment | block-wise-levels-Control | randomization-decision                                                        | unique-subject-id                    |
|:---------------------------|--------------:|:--------------|:-----------|-------------------------:|-----------------------:|:----------------------------|:--------------------------|:------------------------------------------------------------------------------|:-------------------------------------|
| Flexible PBR Example Trial |             1 | Treatment     | RANDOMIZED |                        1 |                      0 | Treatment:1/4               | Control:0/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.0212203289847821\]   | 0ac06b85-8724-4bbe-8086-e355f760dc70 |
| Flexible PBR Example Trial |             2 | Treatment     | RANDOMIZED |                        2 |                      0 | Treatment:2/4               | Control:0/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.1417948291637\]      | ad773c95-0577-4907-871b-589b89240fe5 |
| Flexible PBR Example Trial |             3 | Control       | RANDOMIZED |                        2 |                      1 | Treatment:2/4               | Control:1/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.703004920156673\]    | 8bffefd5-22e4-42f7-8772-eef4ac6e9e72 |
| Flexible PBR Example Trial |             4 | Control       | RANDOMIZED |                        2 |                      2 | Treatment:2/4               | Control:2/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.525561064947397\]    | 86e25792-4082-40ad-93d2-142a3072e96b |
| Flexible PBR Example Trial |             5 | Treatment     | RANDOMIZED |                        3 |                      2 | Treatment:3/4               | Control:2/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.145504052750766\]    | 6ef43df8-b6cd-49dc-bb7f-8b484fbf6121 |
| Flexible PBR Example Trial |             6 | Treatment     | RANDOMIZED |                        4 |                      2 | Treatment:4/4               | Control:2/4               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.408401624765247\]    | 209b8497-c03b-458b-b47c-daf7713fabe4 |
| Flexible PBR Example Trial |             7 | Control       | RANDOMIZED |                        4 |                      3 | Treatment:4/4               | Control:3/4               | range-set\[Treatment=\[0,0\], Control=\[0,1\]; rav=0.526814301963896\]        | 689ff19d-fdf3-4d68-844c-b2daf6b57179 |
| Flexible PBR Example Trial |             8 | Control       | RANDOMIZED |                        4 |                      4 | Treatment:4/4               | Control:4/4               | range-set\[Treatment=\[0,0\], Control=\[0,1\]; rav=0.828539446461946\]        | a4515415-0615-45af-a46a-a6903c1f3f1e |
| Flexible PBR Example Trial |             9 | Control       | RANDOMIZED |                        4 |                      5 | Treatment:0/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.615094124572352\]    | 7ef26e0b-176e-4f68-bb2a-a531c4c38f43 |
| Flexible PBR Example Trial |            10 | Treatment     | RANDOMIZED |                        5 |                      5 | Treatment:1/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.194894318003207\]    | a9c3f9db-8927-417f-9092-964847a1e288 |
| Flexible PBR Example Trial |            11 | Treatment     | RANDOMIZED |                        6 |                      5 | Treatment:2/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.014120080973953\]    | a1bf7380-0b55-4963-9d03-07dcaedb381d |
| Flexible PBR Example Trial |            12 | Control       | RANDOMIZED |                        6 |                      6 | Treatment:2/2               | Control:2/2               | range-set\[Treatment=\[0,0\], Control=\[0,1\]; rav=0.180169035680592\]        | 9e47ea06-3ff9-4aba-bf86-f998c151b12c |
| Flexible PBR Example Trial |            13 | Treatment     | RANDOMIZED |                        7 |                      6 | Treatment:1/3               | Control:0/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.246198229491711\]    | 657c64b7-ec23-41ec-aa2e-349eae6dc216 |
| Flexible PBR Example Trial |            14 | Control       | RANDOMIZED |                        7 |                      7 | Treatment:1/3               | Control:1/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.508522406220436\]    | 78298724-a418-455b-8c99-c952470d2632 |
| Flexible PBR Example Trial |            15 | Treatment     | RANDOMIZED |                        8 |                      7 | Treatment:2/3               | Control:1/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.000603425083681941\] | 65d7d354-a5b8-4398-8c14-36fbde9a8efa |
| Flexible PBR Example Trial |            16 | Control       | RANDOMIZED |                        8 |                      8 | Treatment:2/3               | Control:2/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.867856977041811\]    | 4b13b261-ea2d-4400-82df-96aa5eede9e5 |
| Flexible PBR Example Trial |            17 | Control       | RANDOMIZED |                        8 |                      9 | Treatment:2/3               | Control:3/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.871452651685104\]    | 0958a7f3-da95-462d-b66a-7c91be5401a2 |
| Flexible PBR Example Trial |            18 | Treatment     | RANDOMIZED |                        9 |                      9 | Treatment:3/3               | Control:3/3               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.758590350393206\]        | 70ad6dbb-af2a-444e-ae28-4d4b4e903055 |
| Flexible PBR Example Trial |            19 | Treatment     | RANDOMIZED |                       10 |                      9 | Treatment:1/2               | Control:0/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.179464610526338\]    | 0e558caf-c64b-4db3-b28b-a3fcc360aa37 |
| Flexible PBR Example Trial |            20 | Control       | RANDOMIZED |                       10 |                     10 | Treatment:1/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.943183079361916\]    | 9e8f46df-8471-4f8b-8c04-f6fd93f0b89f |
| Flexible PBR Example Trial |            21 | Control       | RANDOMIZED |                       10 |                     11 | Treatment:1/2               | Control:2/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.763430547900498\]    | 334afbb5-1c84-4a9d-85c0-36ec40e8faf9 |
| Flexible PBR Example Trial |            22 | Treatment     | RANDOMIZED |                       11 |                     11 | Treatment:2/2               | Control:2/2               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.773297929903492\]        | 60866dc3-cb47-4912-8fe0-948d43104283 |
| Flexible PBR Example Trial |            23 | Control       | RANDOMIZED |                       11 |                     12 | Treatment:0/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.591403880855069\]    | 6381fdcd-d63f-46a0-8b84-77dc3775d9ab |
| Flexible PBR Example Trial |            24 | Control       | RANDOMIZED |                       11 |                     13 | Treatment:0/2               | Control:2/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.785737928934395\]    | 3dc8e028-c262-4d20-9120-d62981eb1b14 |
| Flexible PBR Example Trial |            25 | Treatment     | RANDOMIZED |                       12 |                     13 | Treatment:1/2               | Control:2/2               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.296541688032448\]        | 710a87b3-eaeb-451d-bed2-a6211be5c4cd |
| Flexible PBR Example Trial |            26 | Treatment     | RANDOMIZED |                       13 |                     13 | Treatment:2/2               | Control:2/2               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.0567047209478915\]       | b48788d3-d2fb-4edc-a801-eab35c2e3b8a |
| Flexible PBR Example Trial |            27 | Control       | RANDOMIZED |                       13 |                     14 | Treatment:0/3               | Control:1/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.73090074188076\]     | 303ba20d-3078-4afe-a0b9-9074a88f1220 |
| Flexible PBR Example Trial |            28 | Treatment     | RANDOMIZED |                       14 |                     14 | Treatment:1/3               | Control:1/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.110916475299746\]    | 3ae5f9d2-9d96-41a6-8025-6a2bf7228360 |
| Flexible PBR Example Trial |            29 | Control       | RANDOMIZED |                       14 |                     15 | Treatment:1/3               | Control:2/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.887901743175462\]    | abbbbd9a-ca65-4cb1-807c-d99b3e445609 |
| Flexible PBR Example Trial |            30 | Treatment     | RANDOMIZED |                       15 |                     15 | Treatment:2/3               | Control:2/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.125286859693006\]    | 102d8ae2-18cf-4b63-98fb-762ccdbea0fe |
| Flexible PBR Example Trial |            31 | Control       | RANDOMIZED |                       15 |                     16 | Treatment:2/3               | Control:3/3               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.727101013064384\]    | 78444e92-6c9f-4d2f-a7ae-df94d552cedf |
| Flexible PBR Example Trial |            32 | Treatment     | RANDOMIZED |                       16 |                     16 | Treatment:3/3               | Control:3/3               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.0377451616805047\]       | c8bc6ec4-0245-4bfb-aa82-6e02dad8d655 |
| Flexible PBR Example Trial |            33 | Control       | RANDOMIZED |                       16 |                     17 | Treatment:0/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.52538527501747\]     | 27375e0b-0ea1-4ec0-81c4-0da2f77176a0 |
| Flexible PBR Example Trial |            34 | Treatment     | RANDOMIZED |                       17 |                     17 | Treatment:1/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.0736770003568381\]   | 46293098-9d93-4cf4-92df-3a93995d233a |
| Flexible PBR Example Trial |            35 | Treatment     | RANDOMIZED |                       18 |                     17 | Treatment:2/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.485733987297863\]    | 7a6c2ab1-a22e-487f-8a5a-7a6203ca37a4 |
| Flexible PBR Example Trial |            36 | Control       | RANDOMIZED |                       18 |                     18 | Treatment:2/2               | Control:2/2               | range-set\[Treatment=\[0,0\], Control=\[0,1\]; rav=0.719684938434511\]        | 463f7b69-d7ed-40a1-9787-c89d7fa0aa00 |
| Flexible PBR Example Trial |            37 | Control       | RANDOMIZED |                       18 |                     19 | Treatment:0/2               | Control:1/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.965410947334021\]    | 06e791e5-8b62-4e4d-883e-a8ab718bd76d |
| Flexible PBR Example Trial |            38 | Control       | RANDOMIZED |                       18 |                     20 | Treatment:0/2               | Control:2/2               | range-set\[Treatment=\[0,0.5\], Control=\[0.5,1\]; rav=0.812460775719956\]    | 7f389019-2266-4ea7-8d38-6f6c6e1e06ee |
| Flexible PBR Example Trial |            39 | Treatment     | RANDOMIZED |                       19 |                     20 | Treatment:1/2               | Control:2/2               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.205702553037554\]        | 379839d5-67f3-4d41-a0cb-8116b88550d5 |
| Flexible PBR Example Trial |            40 | Treatment     | RANDOMIZED |                       20 |                     20 | Treatment:2/2               | Control:2/2               | range-set\[Treatment=\[0,1\], Control=\[1,1\]; rav=0.0162965569179505\]       | 27bc54e0-c55b-4ec3-bbc2-7af74e169784 |

## System Information

- System: R version 4.5.2 (2025-10-31)  
- randomforge version: 0.1.0.9046  
- Platform: x86_64-pc-linux-gnu  
- Working directory: /home/runner/work/randomforge/randomforge/vignettes
