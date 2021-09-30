# Your new personal google drive-made website!

A template for your personal website and CV!

Learn more about me! [Find my website here.](https://emilyhmarkowitz.github.io/emilyhmarkowitz/)

# Directions

Once everything in place, simply run this *ONE* line of code to get your final website!

`source("./run.R")`

### Notes

#### Prep work and light reading

1. [Authorize Googledrive in R](https://googledrive.tidyverse.org/reference/drive_auth.html)
2. [Learn more about creating a GitHub Page](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)
3. [Nick Strayer - livefreeordichotomize.com: The original inspiration for this project describing how to make a reproducible CV with google spreadsheets](https://livefreeordichotomize.com/2019/09/04/building_a_data_driven_cv_with_r/)
4. [More about making websites in R Markdown](https://www.emilyzabor.com/tutorials/rmarkdown_websites_tutorial.html)
5. [The {distill} R package, for making beautiful R Markdown web pages](https://rstudio.github.io/distill/)
6. [rstudio4edu: Make your RMD Fancy!](https://rstudio4edu.github.io/rstudio4edu-book/rmd-fancy.html#select-and-import-your-google-fonts-script-1)

#### In run.R

1. Fork this repository so you can make as many changes as you want!
2. Make copies of your own bio and cv_data google drive files and start filling them in. 
   - [EXAMPLE Word document with Bio](https://docs.google.com/document/d/1MbDrWQMzXn_3pxpuEnlHiX0juOhvwQtGGUrRLkkrczQ/edit?usp=sharing)
   - [EXAMPLE Spreadsheet with CV data](https://docs.google.com/spreadsheets/d/1fj0-LgxIgHC9qprjDfoyFqOUtUcWGMbMS28mCWf6as8)
3. Define yourname and yourwebsitelink in the "Knowns" section
4. Rename pages as you like, but you must have an index and an about page. 
5. Check that your .gitignore includes your data folder, so it only shares what you want it to show. I inlcuded my data folder here for the sake of the example. 

#### In other files, check for any other things you may want to change

1. **cv_data**: This is where all of the content for your website will come from!
2. **bio**: You can use the google doc or type your bio into the about.rmd directly - up to you!
3. **footer.html**: Change the name in the footer - I couldn't automate thta from "yourname"
4. **_site.yml**: Change the name next to your logo - I couldn't automate thta from "yourname"
5. **add files in the "./img/" folder and replace links throughout your .rmds and cv_data google spreadsheet**

#### Once all files are run and ready to be shared to GitHub Pages

1. In your repo, go into settings > pages. There select Branch = "Main", Folder = "docs", and save. [Learn more about creating a GitHub Page, here.](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)
2. A link should appear on the page with the location of your new GitHub page. 
3. It might take a few minutes for the page to actually appear, so take a mental break while making a cup of tea and watering your plants. 
4. Check out your beautiful new site!


