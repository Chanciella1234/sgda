package com.sgda.service.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ChartSeriesData implements Serializable {

    private String primaryLabel;
    private String secondaryLabel;
    private List<String> labels = new ArrayList<>();
    private List<Long> primaryValues = new ArrayList<>();
    private List<Long> secondaryValues = new ArrayList<>();

    public String getPrimaryLabel() {
        return primaryLabel;
    }

    public void setPrimaryLabel(String primaryLabel) {
        this.primaryLabel = primaryLabel;
    }

    public String getSecondaryLabel() {
        return secondaryLabel;
    }

    public void setSecondaryLabel(String secondaryLabel) {
        this.secondaryLabel = secondaryLabel;
    }

    public List<String> getLabels() {
        return labels;
    }

    public void setLabels(List<String> labels) {
        this.labels = labels;
    }

    public List<Long> getPrimaryValues() {
        return primaryValues;
    }

    public void setPrimaryValues(List<Long> primaryValues) {
        this.primaryValues = primaryValues;
    }

    public List<Long> getSecondaryValues() {
        return secondaryValues;
    }

    public void setSecondaryValues(List<Long> secondaryValues) {
        this.secondaryValues = secondaryValues;
    }
}
