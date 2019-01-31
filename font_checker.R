checkDir <- commandArgs(trailingOnly = T)[1]
setwd(checkDir)
fileNames <- list.files()

invisible(lapply(fileNames, function(file) {
  info <- system(paste("pdffonts", file, "| nkf -w"), intern = TRUE)
  embNum <- as.integer(strsplit(system(paste("pdffonts", file, "| grep -o -b emb"), intern = TRUE), ":")[[1]][1]) + 1
  nameLastNum <- as.integer(strsplit(system(paste("pdffonts", fileNames[1], "| grep -o -b type"), intern = TRUE), ":")[[1]][1]) - 1

  emb <- gsub(" *$", "", substr(info, embNum, embNum + 2))
  name <- gsub(" *$", "", substr(info, 1, nameLastNum))

  results <- name[emb == "no"]

  if(length(results) != 0) cat(file, "\n", sprintf("  %s\n", results), "\n")
}))
