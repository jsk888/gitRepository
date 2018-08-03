package com.mushiny.wms.masterdata.obbasics.common.constants;

public enum DocumentTypes {

    APPLICATION_PDF,
    APPLICATION_MSWORD,
    APPLICATION_MSEXCEL,
    APPLICATION_RTF,
    IMAGE_BMP,
    IMAGE_JPG,
    IMAGE_PNG,
    TEXT_HTML,
    TEXT_RTF,
    TEXT_XML,
    TEXT_PLAIN;

    public String toString() {
        switch (this) {
            case APPLICATION_PDF:
                return "application/pdf";
            case APPLICATION_MSWORD:
                return "application/msword";
            case APPLICATION_MSEXCEL:
                return "application/msexcel";
            case APPLICATION_RTF:
                return "application/rtf";
            case IMAGE_BMP:
                return "image/bmp";
            case IMAGE_JPG:
                return "image/jpg";
            case IMAGE_PNG:
                return "image/png";
            case TEXT_HTML:
                return "text/html";
            case TEXT_RTF:
                return "text/rtf";
            case TEXT_XML:
                return "text/xml";
            default:
                return "text/plain";
        }
    }
}
