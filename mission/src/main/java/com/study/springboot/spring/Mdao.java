package com.study.springboot.spring;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Mdao {
	void addlist(String id, String name, String gender, String country, String city);
	ArrayList<Mdto> getList();
	void updatelist(String id, String name, String gender, String country, String city);
	void deletelist(String id);
	ArrayList<Mdto> selectlist(String id, String name, String gender, String country, String city, String start, String end);
}
