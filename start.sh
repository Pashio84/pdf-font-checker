#!/bin/sh

read -p "PDFが格納されているディレクトリを指定 > " check_dir
Rscript font_checker.R $check_dir > result.txt
