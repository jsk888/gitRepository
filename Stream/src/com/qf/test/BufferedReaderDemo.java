package com.qf.test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/*
 * ��ȡ��������
 */
public class BufferedReaderDemo {

	public static void main(String[] args) {
		BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
        System.out.println("�����룺");
        try {
			String str=br.readLine();
			System.out.println("������������ǣ�"+str);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
