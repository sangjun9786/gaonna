package com.gaonna.yami.chat.common;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class ApplicationContextProvider implements ApplicationContextAware {
    private static ApplicationContext context;
    public static <T> T getBean(Class<T> clazz) {
        return context.getBean(clazz);
    }
    @Override
    public void setApplicationContext(ApplicationContext ac) {
        context = ac;
    }
}