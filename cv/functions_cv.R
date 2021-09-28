# This file contains all the code needed to parse and print various sections of your CV
# from data. Feel free to tweak it as you desire!



# Knowns -----------------------------------------------------------------------

months <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

# Functions --------------------------------------------------------------------

secttitle <- function(txt = "", img = NULL) {

  if (!is.null(img)){
    str <- paste0("## ![](./images/",img,"){width='50px'} *",txt,"*")
  } else {
    str <- paste0("<br>

                ## *",txt,"*")
  }
  return(str)
}

group_rows <- function (dat, col) {

  groups <- data.frame()
  gr0 <- as.character(unlist(unique(dat[,col])))

  for (i in 1:length(gr0)) {
    gr <- gr0[i]
    gr_r <- which(dat[,col] == gr)
    if (length(gr_r) == 1) {
      gr_r <- c(gr_r, gr_r)
    } else {
      gr_r <- c(gr_r[1], gr_r[length(gr_r)])
    }
    groups <- rbind.data.frame(groups,
                               data.frame(group = gr,
                                          st = gr_r[1],
                                          end = gr_r[2]))
  }

  return(groups)
}


#' Check that your links work
#'
#' @param URLs A vector of strings with website URLs, local directories, and/or local files.
#' @param quiet default = FALSE. Will not return messages if = TRUE.
#'
#' @return
#' @export
#'
#' @examples
#' # Use test page URL:
#'   URLs <- c(
#'     "https://github.com",
#'     "http://steipe.biochemistry.utoronto.ca/abc/assets/testCheckLinks.html",
#'     "./",
#'     "./ex.txt",
#'     "./aa/")
#'  checkLinks(URLs)
checkLinks <- function(URLs,
                       quiet = FALSE) {

  # https://stackoverflow.com/questions/31214361/what-is-the-r-equivalent-for-excel-iferror

  URLs <- URLs[!is.na(URLs)] # remove empty rows

  notworking <- c()

  for (i in 1:length(URLs)){

    # Fix URLs if local directories
    URL <- URLs[i]

    if (substr(x = URL, start = 1, stop = 2) == "./") {
      if (URL == "./") {
        URL <- gsub(replacement = getwd(), pattern = "./",
                    x = URL, fixed = TRUE, useBytes = TRUE)
      } else {
        URL <- gsub(replacement = paste0(getwd(), "/"), pattern = "./",
                    x = URL, fixed = TRUE, useBytes = TRUE)
      }

    }

    if (substr(x = URL, start = nchar(URL), stop = nchar(URL)) == "/") {
      URL <- substr(x = URL, start = 1, stop = (nchar(URL)-1))
    }

    # download page and access URLs. If does not exist, collect it in "badurl"
    myPage <- try(expr = xml2::read_html(URL), silent = T)
    if (grepl(pattern = "Error", x = myPage[1],
              fixed = TRUE, useBytes = TRUE) &
        isFALSE(file.exists(URL))) {

      notworking <- c(notworking, URL)
    }
  }

  if (quiet == FALSE){
    if (length(notworking) == 0) {
      print("All links are good!")
    } else {
      print(paste0("There ",
                   ifelse(length(notworking)>1, "are ", "is "),
                   length(notworking),
                   " bad link",
                   ifelse(length(notworking)>1, "s", ""),
                   "."))
    }
  }

  return(notworking)
}



copyedit <- function(format,
                     pattern,
                     x) {
  for (i in 1:length(pattern)){
    if (format == "italics"){
      xx <- gsub(pattern = pattern[i],
                 replacement = paste0("*", pattern[i], "*"),
                 x = x)
    }

    if (format == "bold"){
      xx <- gsub(pattern = pattern[i],
                 replacement = paste0("**", pattern[i], "**"),
                 x = x)
    }
  }
  return(xx)
}




#' Create a CV_Printer object.
#'
#' @param data_location Path of the spreadsheets holding all your data. This can
#'   be either a URL to a google sheet with multiple sheets containing the four
#'   data types or a path to a folder containing four `.csv`s with the neccesary
#'   data.
#' @param source_location Where is the code to build your CV hosted?
#' @param pdf_mode Is the output being rendered into a pdf? Aka do links need to
#'   be stripped?
#' @param sheet_is_publicly_readable If you're using google sheets for data, is
#'   the sheet publicly available? (Makes authorization easier.)
#' @param cache_data If set to true when data is read in it will be saved to an
#'   `.rds` object so it doesn't need to be repeatedly pulled from google
#'   sheets. This is also nice when you have non-public sheets that don't play
#'   nice with authentication during the knit process.
#' @return A new `CV_Printer` object.
create_CV_object <-  function(data_location,
                              pdf_mode = FALSE,
                              sheet_is_publicly_readable = TRUE,
                              cache_data = TRUE) {

  cv <- list(
    pdf_mode = pdf_mode,
    links = c(),
    cache_data = cache_data
  ) %>%
    load_data(data_location, sheet_is_publicly_readable)


  extract_year <- function(dates){
    date_year <- stringr::str_extract(dates, "(20|19)[0-9]{2}")
    date_year[is.na(date_year)] <- lubridate::year(lubridate::ymd(Sys.Date())) + 10

    date_year
  }

  parse_dates <- function(dates){

    date_month <- stringr::str_extract(dates, "(\\w+|\\d+)(?=(\\s|\\/|-)(20|19)[0-9]{2})")
    date_month[is.na(date_month)] <- "1"

    paste("1", date_month, extract_year(dates), sep = "-") %>%
      lubridate::dmy()
  }

  # # Clean up entries dataframe to format we need it for printing
  # cv$entries_data %<>%
  #   tidyr::unite(
  #     tidyr::starts_with('description'),
  #     col = "description_bullets",
  #     sep = "\n- ",
  #     remove = FALSE,
  #     na.rm = TRUE
  #   ) #%>%
  #
  # cv$entries_data %<>%
  #   dplyr::mutate(
  #     description_bullets =
  #       ifelse(description_bullets != "", paste0("- ", description_bullets), "")) %>%
  #   dplyr::mutate(
  #     timeline =
  #       dplyr::case_when(grepl(pattern = "[a-zA-Z]+", x = start) ~ start, # in review, in prep, etc.
  #                        is.na(start) ~ "",
  #                        is.na(end) ~ as.character(start),
  #                        ((!is.na(start) & !is.na(end)) | (start == end)) ~
  #                          paste0(start, "-", end))
  #
  #   ) %>%
  #
  #   # start = ifelse(start == "NULL", NA, start),
  #   # end = ifelse(end == "NULL", NA, end),
  #   # start_year = extract_year(start),
  #   # end_year = extract_year(end),
  #   # no_start = is.na(start),
  #   # has_start = !no_start,
  #   # no_end = is.na(end),
  #   # has_end = !no_end,
  #   # timeline = dplyr::case_when(
  #   #
  # #   no_start  & no_end  ~ 'N/A',
  # #   no_start  & has_end ~ as.character(end),
  # #   has_start & no_end  ~ paste("Current", "-", start),
  # #   TRUE                ~ paste(end, "-", start)
  # # )
  # # ) %>%
  # dplyr::arrange(desc(parse_dates(end))) %>%
  #   dplyr::mutate_all(~ ifelse(is.na(.), 'N/A', .))

  return(cv)
}

# Load data for CV
load_data <- function(cv, data_location, sheet_is_publicly_readable){
  cache_loc <- "ddcv_cache.rds"
  has_cached_data <- fs::file_exists(cache_loc)
  is_google_sheets_location <- stringr::str_detect(data_location, "docs\\.google\\.com")

  if(has_cached_data & cv$cache_data){

    cv <- c(cv, readr::read_rds(cache_loc))
  } else if(is_google_sheets_location){
    if(sheet_is_publicly_readable){
      # This tells google sheets to not try and authenticate. Note that this will only
      # work if your sheet has sharing set to "anyone with link can view"
      # googlesheets4::sheets_deauth()
      googledrive::drive_auth()
    } else {
      # My info is in a public sheet so there's no need to do authentication but if you want
      # to use a private sheet, then this is the way you need to do it.
      # designate project-specific cache so we can render Rmd without problems
      options(gargle_oauth_cache = ".secrets")
    }

    read_gsheet <- function(sheet_id){
      googlesheets4::read_sheet(data_location, sheet = sheet_id, skip = 1, col_types = "c")
    }
    cv$entries_data  <- read_gsheet(sheet_id = "entries")
    cv$skills        <- read_gsheet(sheet_id = "language_skills")
    cv$text_blocks   <- read_gsheet(sheet_id = "text_blocks")
    cv$contact_info  <- read_gsheet(sheet_id = "contact_info")
  } else {
    # Want to go old-school with csvs?
    cv$entries_data <- readr::read_csv(paste0(data_location, "entries.csv"), skip = 1)
    cv$skills       <- readr::read_csv(paste0(data_location, "language_skills.csv"), skip = 1)
    cv$text_blocks  <- readr::read_csv(paste0(data_location, "text_blocks.csv"), skip = 1)
    cv$contact_info <- readr::read_csv(paste0(data_location, "contact_info.csv"), skip = 1)
  }

  if(cv$cache_data & !has_cached_data){
    # Make sure we only cache the data and not settings etc.
    readr::write_rds(
      list(
        entries_data = cv$entries_data,
        skills = cv$skills,
        text_blocks = cv$text_blocks,
        contact_info = cv$contact_info
      ),
      cache_loc
    )

    cat(glue::glue("CV data is cached at {cache_loc}.\n"))
  }

  invisible(cv)
}


# Remove links from a text block and add to internal list
sanitize_links <- function(cv, text){
  if(cv$pdf_mode){
    link_titles <- stringr::str_extract_all(text, '(?<=\\[).+?(?=\\]\\()')[[1]]
    link_destinations <- stringr::str_extract_all(text, '(?<=\\]\\().+?(?=\\))')[[1]]

    n_links <- length(cv$links)
    n_new_links <- length(link_titles)

    if(n_new_links > 0){
      # add links to links array
      cv$links <- c(cv$links, link_destinations)

      # Build map of link destination to superscript
      link_superscript_mappings <- purrr::set_names(
        paste0("<sup>", (1:n_new_links) + n_links, "</sup>"),
        paste0("(", link_destinations, ")")
      )

      # Replace the link destination and remove square brackets for title
      text <- text %>%
        stringr::str_replace_all(stringr::fixed(link_superscript_mappings)) %>%
        stringr::str_replace_all('\\[(.+?)\\](?=<sup>)', "\\1")
    }
  }

  list(cv = cv, text = text)
}


#' @description Take a position data frame and the section id desired and prints the section to markdown.
#' @param section_id ID of the entries section to be printed as encoded by the `section` column of the `entries` table
print_section <- function(cv, section_id, glue_template = "default"){

  if(glue_template == "default"){
    glue_template <- "
### {title}

{loc}

{institution}

{timeline}

{description_bullets}

{Links_inline}

\n\n\n"
  } else if (glue_template == "list"){
    glue_template <- '

<h3 style="margin-left: 85px"> - **{title}**, {timeline}</h3>

\n\n\n'
  }

  section_data <- dplyr::filter(cv$entries_data, section == section_id)

  # Take entire entries data frame and removes the links in descending order
  # so links for the same position are right next to each other in number.
  for(i in 1:nrow(section_data)){
    for(col in c('title', 'description_bullets')){
      strip_res <- sanitize_links(cv, section_data[i, col])
      section_data[i, col] <- strip_res$text
      cv <- strip_res$cv
    }
  }

  print(glue::glue_data(section_data, glue_template))

  invisible(strip_res$cv)
}



#' @description Prints out text block identified by a given label.
#' @param label ID of the text block to print as encoded in `label` column of `text_blocks` table.
print_text_block <- function(cv, label){
  text_block <- dplyr::filter(cv$text_blocks, loc == label) %>%
    dplyr::pull(text)

  strip_res <- sanitize_links(cv, text_block)

  cat(strip_res$text)

  invisible(strip_res$cv)
}



#' @description Construct a bar chart of skills
#' @param out_of The relative maximum for skills. Used to set what a fully filled in skill bar is.
print_skill_bars <- function(cv, out_of = 5, bar_color = "#969696", bar_background = "#d9d9d9", glue_template = "default"){

  if(glue_template == "default"){
    glue_template <- "
<div
  class = 'skill-bar'
  style = \"background:linear-gradient(to right,
                                      {bar_color} {width_percent}%,
                                      {bar_background} {width_percent}% 100%);\"
>{skill}</div>"
  }
  cv$skills %>%
    dplyr::mutate(width_percent = round(100*as.numeric(level)/out_of)) %>%
    glue::glue_data(glue_template) %>%
    print()

  invisible(cv)
}



#' @description List of all links in document labeled by their superscript integer.
print_links <- function(cv) {
  n_links <- length(cv$links)
  if (n_links > 0) {
    cat("
Links {data-icon=link}
--------------------------------------------------------------------------------

<br>


")

    purrr::walk2(cv$links, 1:n_links, function(link, index) {
      print(glue::glue('{index}. {link}'))
    })
  }

  invisible(cv)
}



#' @description Contact information section with icons
print_contact_info <- function(cv){
  glue::glue_data(
    cv$contact_info,
    "- <i class='fa fa-{icon}'></i> {contact}"
  ) %>% print()

  invisible(cv)
}
