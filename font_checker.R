library(stringr)

checkDir <- commandArgs(trailingOnly = T)[1]
# checkDir <- "/run/user/1000/gvfs/smb-share:server=eggplant,share=assist,user=assist/work_files/庶務/卒研梗概集/2019/梗概集/矢島研"
setwd(checkDir)
fileNames <- list.files()
fileNames <- fileNames[!dir.exists(fileNames)][grep(".*\\.pdf", fileNames)]

cat("フォント埋め込みがされていないデータ一覧\n\n")

invisible(lapply(fileNames, function(file) {
  info <- system(paste("pdffonts", file, "| nkf -w"), intern = TRUE)[-(1:2)]
  infoSplit <- str_split(info, pattern = " ")
  doubleByteChar <- apply(str_extract_all(info, pattern=".", simplify=TRUE), 1, function(rowData) grep("[^\x01-\x7E]", rowData))

  nameLastNum <- as.integer(strsplit(system(paste("pdffonts", fileNames[1], "| grep -o -b type"), intern = TRUE), ":")[[1]][1]) - 1
  if(length(doubleByteChar) != 0) {
    doubleByteName <- unlist(lapply(doubleByteChar, function(word) length(word[word < nameLastNum])))
    nameLastNum <- rep(nameLastNum, length(info)) - doubleByteName
  }

  emb <- unlist(lapply(infoSplit, function(font) font[font == "yes" | font == "no"][1]))
  name <- gsub(" *$", "", substr(info, 1, nameLastNum))

  results <- name[emb == "no"]

  if(length(results) != 0) cat(file, "\n", sprintf("  %s\n", results), "\n")
}))
