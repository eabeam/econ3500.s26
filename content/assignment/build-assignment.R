build_lab_pdf <- function(file) {
  repo <- "/Users/ebeam/Dropbox/GitHub/econ3500.s26"
  lua  <- file.path(repo, "content/assignment/rewrite-img.lua")

  in_file  <- normalizePath(file)
  out_file <- sub("\\.Rmd$", ".pdf", in_file)

  args <- c(
    "-f", "markdown",
    in_file,
    paste0("--lua-filter=", lua),
    paste0("--resource-path=", file.path(repo, "static")),
    "--pdf-engine=xelatex",
    "-o", out_file
  )

  res <- system2("pandoc", args = args, stdout = TRUE, stderr = TRUE)
  cat(paste(res, collapse = "\n"), "\n")

  invisible(out_file)
}

build_lab_pdf("/Users/ebeam/Dropbox/GitHub/econ3500.s26/content/assignment/01-lab.Rmd")
