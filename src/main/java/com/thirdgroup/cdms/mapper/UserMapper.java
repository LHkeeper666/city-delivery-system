
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

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