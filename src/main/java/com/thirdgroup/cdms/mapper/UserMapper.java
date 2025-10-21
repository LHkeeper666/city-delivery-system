
package com.thirdgroup.cdms.mapper;

import com.thirdgroup.cdms.entity.User;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserMapper {
    int insert(User record);
    int deleteByPrimaryKey(Long userId);
    int updateByPrimaryKey(User record);
    User selectByPrimaryKey(Long userId);
    List<User> selectAll();
}