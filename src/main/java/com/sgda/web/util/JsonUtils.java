package com.sgda.web.util;

import com.sgda.service.dto.ChartSeriesData;
import java.util.Iterator;
import java.util.List;

public final class JsonUtils {

    private JsonUtils() {
    }

    public static String toJson(ChartSeriesData data) {
        StringBuilder builder = new StringBuilder(256);
        builder.append('{')
                .append("\"primaryLabel\":\"").append(escape(data.getPrimaryLabel())).append("\",")
                .append("\"secondaryLabel\":\"").append(escape(data.getSecondaryLabel())).append("\",")
                .append("\"labels\":").append(toJsonStringArray(data.getLabels())).append(',')
                .append("\"primaryValues\":").append(toJsonNumberArray(data.getPrimaryValues())).append(',')
                .append("\"secondaryValues\":").append(toJsonNumberArray(data.getSecondaryValues()))
                .append('}');
        return builder.toString();
    }

    private static String toJsonStringArray(List<String> values) {
        StringBuilder builder = new StringBuilder("[");
        Iterator<String> iterator = values.iterator();
        while (iterator.hasNext()) {
            builder.append('"').append(escape(iterator.next())).append('"');
            if (iterator.hasNext()) {
                builder.append(',');
            }
        }
        builder.append(']');
        return builder.toString();
    }

    private static String toJsonNumberArray(List<Long> values) {
        StringBuilder builder = new StringBuilder("[");
        Iterator<Long> iterator = values.iterator();
        while (iterator.hasNext()) {
            builder.append(iterator.next());
            if (iterator.hasNext()) {
                builder.append(',');
            }
        }
        builder.append(']');
        return builder.toString();
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder builder = new StringBuilder(value.length());
        for (int index = 0; index < value.length(); index += 1) {
            char current = value.charAt(index);
            switch (current) {
                case '\\':
                    builder.append("\\\\");
                    break;
                case '"':
                    builder.append("\\\"");
                    break;
                case '\n':
                    builder.append("\\n");
                    break;
                case '\r':
                    builder.append("\\r");
                    break;
                case '\t':
                    builder.append("\\t");
                    break;
                default:
                    builder.append(current);
                    break;
            }
        }
        return builder.toString();
    }
}
