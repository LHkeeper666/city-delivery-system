
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
//可能push的时候有一个文件也叫usermapper
@Mapper
public interface UserMapper {
    int insert(User record);
    int deleteByPrimaryKey(Long userId);
    int updateByPrimaryKey(User record);
    User selectByPrimaryKey(Long userId);
    List<User> selectAll();

    /**
     * 根据用户名查找 user
     *
     * @param username
     * @return
     */
    User selectByUsername(String username);
}