package com.qf.test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class OutputStreamDemo {
  public static void main(String[] args) {
	OutputStream out=null;
	try {
		out=new FileOutputStream("E:"+File.separator+"a.txt",true);
		out.write("\r\n���".getBytes());
		System.out.println("д��ɹ�");
	} catch (Exception e) {
		e.printStackTrace();
	}finally{
		try {
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
}
