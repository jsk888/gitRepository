package com.jsk.test;

public class Person {
   private String name;
   private int age;
public Person() {
	super();
	// TODO �Զ����ɵĹ��캯�����
}
public Person(String name, int age) {
	super();
	this.name = name;
	this.age = age;
}
public void enjoy(Course c){
	System.out.println(name+"ϲ���γ��ǣ�"+c.getName()+"���γ̱���ǣ�"+c.getId());
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public int getAge() {
	return age;
}
public void setAge(int age) {
	this.age = age;
}
   
}
