import os
import sys
import time
try:
    import xlwings as xw 
except ImportError:
    import pip
    pip.main(["install", "--user", "xlwings"])
    # os.system('pip install requests') 
    import xlwings as xw 

indexId = int(sys.argv[3]) - 1
if indexId < 0:
    indexId = 0
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"准备打开excel处理工具")
app=xw.App(visible=False,add_book=False)
app.display_alerts = False
app.screen_updating = False

excel1 = app.books.open(sys.argv[1])
excel1Sheet = excel1.sheets[0]
excel1Rows, excel1Cols = excel1Sheet.used_range.shape
excel1Headings = excel1Sheet[0, :excel1Cols].value

excel2 = app.books.open(sys.argv[2])
excel2Sheet = excel2.sheets[0]
excel2Rows, excel2Cols = excel2Sheet.used_range.shape
excel2Headings = excel2Sheet[0, :excel2Cols].value
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"已经打开excel处理工具")
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"开始处理数据...")
excel1RowDict = {}
for row in range(1, excel1Rows):
    
    if indexId < excel1Cols:
        colString = excel1Sheet[row, indexId].value
        if colString is not None and len(colString) != 0:
            excel1RowDict[excel1Sheet[row, indexId].value] = row

excel2NeedAppendCol = excel1Cols
if excel2NeedAppendCol < excel2Cols:
    if indexId < excel1Cols:
        excel1Sheet.range((1, indexId), (excel1Rows + excel2Rows, indexId)).api.NumberFormat = "@"
        excel2Sheet.range((1, indexId), (excel2Rows, indexId)).api.NumberFormat = "@"
    print("处理数据中...")
    for row in range(2, excel2Rows):
        
        if indexId < excel1Cols:
            colString = excel2Sheet[row, indexId].value
            if colString is not None and len(colString) != 0:
                if colString in excel1RowDict:
                    #找到有的，数据做拼接
                    excel1HasRow = excel1RowDict[colString]
                    if excel1HasRow is not None:
                        excel1Sheet[excel1HasRow, excel2NeedAppendCol].value=excel2Sheet[row, excel2NeedAppendCol].value
                else: 
                    for col in range(excel2Cols):
                        if col == indexId : 
                            excel1Sheet[excel1Rows, col].value = str(excel2Sheet[row, col].value)+"_"
                        else:
                            excel1Sheet[excel1Rows, col].value = excel2Sheet[row, col].value
                    excel1Rows = excel1Rows + 1
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"数据处理完成")
excel1Sheet.autofit()
excel1.save()
excel1.close()
excel2.close()
app.quit()
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"已关闭excel处理工具")
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "："+"此目录中的name文件就是您的合并文件了")


# def main():
#     indexId = int(sys.argv[3]) - 1
#     if indexId < 0:
#         indexId = 0
#     app=xw.App(visible=False,add_book=False)
#     app.display_alerts = False
#     app.screen_updating = False

#     excel1 = app.books.open(sys.argv[1])
#     excel1Sheet = excel1.sheets[0]
#     excel1Rows, excel1Cols = excel1Sheet.used_range.shape
#     excel1Headings = excel1Sheet[0, :excel1Cols].value

#     excel2 = app.books.open(sys.argv[2])
#     excel2Sheet = excel2.sheets[0]
#     excel2Rows, excel2Cols = excel2Sheet.used_range.shape
#     excel2Headings = excel2Sheet[0, :excel2Cols].value

#     excel1RowDict = {}
#     for row in range(1, excel1Rows):
        
#         if indexId < excel1Cols:
#             colString = excel1Sheet[row, indexId].value
#             if colString is not None and len(colString) != 0:
#                 excel1RowDict[excel1Sheet[row, indexId].value] = row

#     excel2NeedAppendCol = excel1Cols
#     if excel2NeedAppendCol < excel2Cols:
#         if indexId < excel1Cols:
#             excel1Sheet.range((1, indexId), (excel1Rows + excel2Rows, indexId)).api.NumberFormat = "@"
#             excel2Sheet.range((1, indexId), (excel2Rows, indexId)).api.NumberFormat = "@"
#         for row in range(2, excel2Rows):
            
#             if indexId < excel1Cols:
#                 colString = excel2Sheet[row, indexId].value
#                 if colString is not None and len(colString) != 0:
#                     if colString in excel1RowDict:
#                         #找到有的，数据做拼接
#                         excel1HasRow = excel1RowDict[colString]
#                         if excel1HasRow is not None:
#                             excel1Sheet[excel1HasRow, excel2NeedAppendCol].value=excel2Sheet[row, excel2NeedAppendCol].value
#                     else: 
#                         for col in range(excel2Cols):
#                             if col == indexId : 
#                                 excel1Sheet[excel1Rows, col].value = str(excel2Sheet[row, col].value)+"_"
#                             else:
#                                 excel1Sheet[excel1Rows, col].value = excel2Sheet[row, col].value
#                         excel1Rows = excel1Rows + 1
                        
#     excel1Sheet.autofit()
#     excel1.save()
#     excel1.close()
#     excel2.close()
#     app.quit()
# if __name__ == "__main__":
#     main()