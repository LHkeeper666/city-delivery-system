
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
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
     * @return user 实体
     */
    User selectByUsername(String username);

    void updateLoginInfoById(
            @Param("userId") Long userId,
            @Param("failCount") int failCount,
            @Param("ip") String ip,
            @Param("success") boolean success,
            @Param("remark") String remark
    );
}