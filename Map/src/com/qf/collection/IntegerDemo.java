package com.qf.collection;

//JVM���Զ�ά�����ֻ������͵ĳ����أ�int�������г�ʼ��-128~127�ķ�Χ��
//���Ե�ΪInteger i=127ʱ�����Զ�װ���������ȡ�Գ������е���ֵ��
//����Integer i=128ʱ��128���ڳ����ط�Χ�ڣ�
//�������Զ�װ���������new 128�����Ե�ַ��һ����
public class IntegerDemo {
	public static void main(String[] args) {
		Integer i = 127;
		Integer j = 127;
		if (i == j) {
			System.out.println("���");
		} else {
			System.out.println("����");
		}
		Integer a = 128;
		Integer b = 128;
		if (a == b) {
			System.out.println("���");
		} else {
			System.out.println("����");
		}
	}
}
