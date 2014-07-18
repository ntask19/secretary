# Samples.IncludeAllFeatures

> --------------------- ------------------------------------------------------------------------------------------
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          Android
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------

## Overview

This is an Android-specific sample.

This project demonstrates how to include all optional libraries that the Corona SDK supports.
This enables the following features in Corona Lua APIs:

* Facebook
* Flurry

Note: Calling a Lua API for a feature whose library is not included can cause an error or crash to occur.

## Code Walkthrough

### Android

* To include Android library projects into your application project, you must reference their directories via the "project.properties" file.
* To include JAR files in your project, you must copy them to your project's "libs" directory.
* Remember to update your "AndroidManifest.xml" file to include any settings that are required by the included libraries.

