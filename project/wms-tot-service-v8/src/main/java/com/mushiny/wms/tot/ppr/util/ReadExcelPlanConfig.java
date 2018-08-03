package com.mushiny.wms.tot.ppr.util;

import com.mushiny.wms.tot.ppr.query.dto.JobCategoryRelationDTO;
import com.mushiny.wms.tot.ppr.repository.JobCategoryRelationRepository;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by hgf on 2017/8/4.
 */
public class ReadExcelPlanConfig {
    //总行数
    private int totalRows = 0;
    //总条数
    private int totalCells = 0;
    //错误信息接收器
    private String errorMsg;

    //构造方法
//    public ReadExcelJob(JobCategoryRelationRepository jobCategoryRelationRepository) {
//        this.jobCategoryRelationRepository = jobCategoryRelationRepository;
//    }

    //获取总行数
    public int getTotalRows() {
        return totalRows;
    }

    //获取总列数
    public int getTotalCells() {
        return totalCells;
    }

    //获取错误信息
    public String getErrorInfo() {
        return errorMsg;
    }

    /**
     * 读EXCEL文件，获取信息集合
     *
     * @param
     * @return
     */
    public List<JobCategoryRelationDTO> getExcelInfo(MultipartFile mFile) {
        String fileName = mFile.getOriginalFilename();//获取文件名
        if (!validateExcel(fileName)) {// 验证文件名是否合格
            return null;
        }
        boolean isExcel2003 = true;// 根据文件名判断文件是2003版本还是2007版本
        if (isExcel2007(fileName)) {
            isExcel2003 = false;
        }
        List<JobCategoryRelationDTO> jobCategoryRelationList = null;
        try {
            jobCategoryRelationList = createExcel(mFile.getInputStream(), isExcel2003);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jobCategoryRelationList;
    }

    /**
     * 根据excel里面的内容读取客户信息
     *
     * @param is          输入流
     * @param isExcel2003 excel是2003还是2007版本
     * @return
     * @throws IOException
     */
    public List<JobCategoryRelationDTO> createExcel(InputStream is, boolean isExcel2003) {
        Workbook wb = null;
        if (isExcel2003) {// 当excel是2003时,创建excel2003
            try {
                wb = new HSSFWorkbook(is);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {// 当excel是2007时,创建excel2007
            try {
                wb = new XSSFWorkbook(is);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        List<JobCategoryRelationDTO> jobCategoryRelationList = readExcelValue(wb);// 读取Excel里面客户的信息

        return jobCategoryRelationList;
    }

    /**
     * 读取Excel里面客户的信息
     *
     * @param wb
     * @return
     */
    public List<JobCategoryRelationDTO> readExcelValue(Workbook wb) {
        // 得到第一个shell
        Sheet sheet = wb.getSheetAt(0);
        // 得到Excel的行数
        this.totalRows = sheet.getPhysicalNumberOfRows();
        // 得到Excel的列数(前提是有行数)
        if (totalRows > 2 && sheet.getRow(0) != null) {
            this.totalCells = sheet.getRow(0).getPhysicalNumberOfCells();
        }
        List<JobCategoryRelationDTO> jobCategoryRelationList = new ArrayList<JobCategoryRelationDTO>();
        // 循环Excel行数
        for (int r = 2; r < totalRows; r++) {
            Row row = sheet.getRow(r);
            if (row == null) {
                continue;
            }
            JobCategoryRelationDTO jobCategoryRelation = new JobCategoryRelationDTO();
            // 循环Excel的列
            for (int c = 0; c < this.totalCells; c++) {
                Cell cell = row.getCell(c);
                if (null != cell) {
                    if (c == 0) {
                        jobCategoryRelation.setMainProcesses(cell.getStringCellValue().trim());
                    } else if (c == 1) {
                        jobCategoryRelation.setCoreProcesses(cell.getStringCellValue().trim());
                    }
                }
            }
            //  添加到list
            jobCategoryRelationList.add(jobCategoryRelation);
        }
        return jobCategoryRelationList;
    }

    /**
     * 验证EXCEL文件
     *
     * @param filePath
     * @return
     */
    public boolean validateExcel(String filePath) {
        if (filePath == null || !(isExcel2003(filePath) || isExcel2007(filePath))) {
            errorMsg = "文件名不是excel格式";
            return false;
        }
        return true;
    }

    // @描述：是否是2003的excel，返回true是2003
    public static boolean isExcel2003(String filePath) {
        return filePath.matches("^.+\\.(?i)(xls)$");
    }

    //@描述：是否是2007的excel，返回true是2007
    public static boolean isExcel2007(String filePath) {
        return filePath.matches("^.+\\.(?i)(xlsx)$");
    }
}
