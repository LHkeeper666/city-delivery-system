package com.thirdgroup.cdms.utils;

import java.util.Calendar;
import java.util.Date;

/**
 * Date方法类
 * 借助 java.util.Calendar 实现对 java.util.Date 的加减操作
 */
public class DateUtils {

    /**
     * 对 Date 进行加减操作
     * @param date 原始时间
     * @param field Calendar 中的时间字段，如 Calendar.DAY_OF_MONTH、Calendar.HOUR_OF_DAY
     * @param amount 增加（正数）或减少（负数）的数量
     * @return 新的 Date 对象
     */
    public static Date add(Date date, int field, int amount) {
        if (date == null) return null;
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(field, amount);
        return cal.getTime();
    }

    // -------------- 常用快捷方法 ----------------

    public static Date addDays(Date date, int days) {
        return add(date, Calendar.DAY_OF_MONTH, days);
    }

    public static Date addHours(Date date, int hours) {
        return add(date, Calendar.HOUR_OF_DAY, hours);
    }

    public static Date addMinutes(Date date, int minutes) {
        return add(date, Calendar.MINUTE, minutes);
    }

    public static Date addSeconds(Date date, int seconds) {
        return add(date, Calendar.SECOND, seconds);
    }

    // -------------- 示例 ----------------
    public static void main(String[] args) {
        Date now = new Date();
        System.out.println("现在: " + now);

        System.out.println("明天: " + addDays(now, 1));
        System.out.println("2小时前: " + addHours(now, -2));
        System.out.println("10分钟后: " + addMinutes(now, 10));
        System.out.println("30秒前: " + addSeconds(now, -30));
    }
}
