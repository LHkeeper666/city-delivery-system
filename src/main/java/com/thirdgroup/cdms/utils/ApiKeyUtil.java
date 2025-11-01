package com.thirdgroup.cdms.utils;

import java.security.SecureRandom;
import java.util.Base64;

public class ApiKeyUtil {
    private static final SecureRandom secureRandom = new SecureRandom();

    public static String generateApiKey() {
        byte[] randomBytes = new byte[32]; // 256-bit key
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
}
