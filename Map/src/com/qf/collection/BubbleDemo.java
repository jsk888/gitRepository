package com.qf.collection;

/*
 * ð�����򣬰��մ�С�����˳������
 */
public class BubbleDemo {
	public static void main(String[] args) {
		int[] a = { 1, 8, 9, 7, 3 };
		BubbleDemo.BubbleSort(a);
	}
	public static void BubbleSort(int[] a) {
		int len = a.length;
		int tem;
		for (int i = 0; i < len; i++) {
			for (int j = 0; j < len - i - 1; j++) {
				if (a[j] > a[j + 1]) {
					tem = a[j];
					a[j] = a[j + 1];
					a[j + 1] = tem;
				}
			}
		}
		for (int s : a) {
			System.out.println(s);
		}
	}
}
