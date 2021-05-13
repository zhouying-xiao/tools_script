import sys
import openpyxl

def txt_xlsx(txtname,excelname): 
	#txtname = 'apk_transformervzw.txt'
	#excelname = 'apk_transformervzw.xlsx'

	#fopen = open(txtname, 'r',encoding='utf-8')
	fopen = open(txtname, 'r')
	lines = fopen.readlines()
	file = openpyxl.Workbook()
	sheet = file.active
	sheet.title = "data"

	i = 0
	for line in lines:
	    line = line.strip('\n')
	    line = line.replace("\t",",")
	    line = line.split(',')
	    for index in range(len(line)):
		sheet.cell(i+1, index+1, line[index])
	    i = i + 1

	file.save(excelname)

if __name__ == '__main__':
    txtname = sys.argv[1]
    excelname = sys.argv[2]
    txt_xlsx(txtname,excelname)

