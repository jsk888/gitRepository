package com.qf.collection;
//��������ֵ���Ͳ�ͬ��Ҳ������
public class OverloadingDemo {
	public static void main(String[] args) {
           add(1,2);
           add(1.0,2.0);
	}
	public static int add(int a, int b) {
		int c = a + b;
		System.out.println(c);
		return c;
	}
	public static double add(double a, double b) {
		double c = a + b;
		System.out.println(c);
		return c;
	}
}
