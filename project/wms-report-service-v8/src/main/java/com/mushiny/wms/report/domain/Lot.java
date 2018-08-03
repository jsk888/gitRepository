package com.mushiny.wms.report.domain;

import com.mushiny.wms.common.entity.BaseClientAssignedEntity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "INV_LOT", uniqueConstraints = {
        @UniqueConstraint(columnNames = {
                "LOT_NO", "ITEMDATA_ID"
        })
})
public class Lot extends BaseClientAssignedEntity {
    private static final long serialVersionUID = 1L;

    @Column(name = "LOT_NO", nullable = false)
    private String lotNo;

    @Column(name = "NAME")
    private String name;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "LOT_DATE", nullable = false)
    private LocalDateTime lotDate;

    @ManyToOne(optional = false)
    @JoinColumn(name = "ITEMDATA_ID")
    private ItemData itemData;

    @Column(name = "USE_NOT_AFTER")
    private LocalDateTime useNotAfter;


    public String getLotNo() {
        return lotNo;
    }

    public void setLotNo(String lotNo) {
        this.lotNo = lotNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getLotDate() {
        return lotDate;
    }

    public void setLotDate(LocalDateTime lotDate) {
        this.lotDate = lotDate;
    }

    public ItemData getItemData() {
        return itemData;
    }

    public void setItemData(ItemData itemData) {
        this.itemData = itemData;
    }

    public LocalDateTime getUseNotAfter() {
        return useNotAfter;
    }

    public void setUseNotAfter(LocalDateTime useNotAfter) {
        this.useNotAfter = useNotAfter;
    }

}
