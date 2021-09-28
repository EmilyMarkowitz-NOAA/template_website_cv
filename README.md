# Your new personal google drive-made website!
"personal_website_cv_template""
A template for your personal website and CV!


Learn more about me! [Find my website here.](https://emilyhmarkowitz.github.io/emilyhmarkowitz/)


# Directions

Simply run this ONE line of code to get your website!

`source("./run.R")`

### Notes

**Prep work and light reading**

1. [Authorize Googledrive in R](https://googledrive.tidyverse.org/reference/drive_auth.html)
2. [Learn more about Git Hub Pages](https://pages.github.com/)
3. [The original inspiration for this project - how to make a reproducible CV with google drive](https://livefreeordichotomize.com/2019/09/04/building_a_data_driven_cv_with_r/)
4. [More about making websites in R Markdown](https://www.emilyzabor.com/tutorials/rmarkdown_websites_tutorial.html)
5. [The {distill} R package, for making beautiful R Markdown web pages](https://rstudio.github.io/distill/)

**In run.R**

1. Fork this repository so you can make as many changes as you want!
2. Make copies of your own bio and cv_data google drive files and start filling them in. 
   - [EXAMPLE Word document with Bio](https://docs.google.com/document/d/1MbDrWQMzXn_3pxpuEnlHiX0juOhvwQtGGUrRLkkrczQ/edit?usp=sharing)
   - [EXAMPLE Spreadsheet with CV data](https://docs.google.com/spreadsheets/d/1fj0-LgxIgHC9qprjDfoyFqOUtUcWGMbMS28mCWf6as8)
3. Define yourname and yourwebsitelink in the "Knowns" section
4. Rename pages as you like, but you must have an index and an about page. 
5. Check that your gitignore includes your data folder, so it only shares what you want it to show. I inlcuded my data folder here for the sake of the example. 

**In other files, check for any other personal data**

1. cv_data
2. bio
3. footer.html
4. _site.yml
5. replace and add files in the ./img/ folder

**Once all files are run and ready to be shared to GitHub Pages**

1. In your repo, go into settings > pages. There select Branch = "Main", Folder = "docs", and save. 
2. A link should appear on the page with the location of your new github page
3. It might take a few minutes for the page to actually appear, so make a cup of tea and water your plants
4. Check out your beautiful new site!


