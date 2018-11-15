package com.mushiny.wms.schedule.domin;

import com.mushiny.wms.common.entity.BaseEntity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "MD_ITEMDATA_GLOBAL")
public class ItemDataGlobal extends BaseEntity {
    private static final long serialVersionUID = 1L;

    @Column(name = "ITEM_NO", nullable = false, unique = true)
    private String itemNo;

    @Column(name = "SKU_NO", nullable = false)
    private String skuNo;

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "SAFETY_STOCK", nullable = false)
    private int safetyStock;


    @Column(name = "LOT_MANDATORY", nullable = false)
    private boolean lotMandatory;


    @Column(name = "SERIAL_RECORD_TYPE", nullable = false)
    private String serialRecordType;

    @Column(name = "LOT_UNIT")
    private String lotUnit;

    @Column(name = "HEIGHT")
    private BigDecimal height;

    @Column(name = "WIDTH")
    private BigDecimal width;

    @Column(name = "DEPTH")
    private BigDecimal depth;

    @Column(name = "VOLUME")
    private BigDecimal volume;

    @Column(name = "WEIGHT")
    private long weight = 0;

    @Column(name = "MULTIPLE_PART", nullable = false)
    private boolean multiplePart;

    @Column(name = "MULTIPLE_PART_AMOUNT")
    private Integer multiplePartAmount;

    @Column(name = "MEASURED")
    private boolean measured;

    @Column(name = "PREFER_OWNBOX", nullable = false)
    private boolean preferOwnBox;

    @Column(name = "PREFER_BAG", nullable = false)
    private boolean preferBag;

    @Column(name = "USE_BUBBLEFILM", nullable = false)
    private boolean useBubbleFilm;

    @ManyToOne(optional = false)
    @JoinColumn(name = "ITEMGROUP_ID")
    private ItemGroup itemGroup;

    @ManyToOne(optional = false)
    @JoinColumn(name = "HANDLINGUNIT_ID")
    private ItemUnit itemUnit;

    public String getItemNo() {
        return itemNo;
    }

    public void setItemNo(String itemNo) {
        this.itemNo = itemNo;
    }

    public String getSkuNo() {
        return skuNo;
    }

    public void setSkuNo(String skuNo) {
        this.skuNo = skuNo;
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

    public int getSafetyStock() {
        return safetyStock;
    }

    public void setSafetyStock(int safetyStock) {
        this.safetyStock = safetyStock;
    }

    public boolean isLotMandatory() {
        return lotMandatory;
    }

    public void setLotMandatory(boolean lotMandatory) {
        this.lotMandatory = lotMandatory;
    }

    public String getSerialRecordType() {
        return serialRecordType;
    }

    public void setSerialRecordType(String serialRecordType) {
        this.serialRecordType = serialRecordType;
    }

    public String getLotUnit() {
        return lotUnit;
    }

    public void setLotUnit(String lotUnit) {
        this.lotUnit = lotUnit;
    }

    public BigDecimal getHeight() {
        return height;
    }

    public void setHeight(BigDecimal height) {
        this.height = height;
    }

    public BigDecimal getWidth() {
        return width;
    }

    public void setWidth(BigDecimal width) {
        this.width = width;
    }

    public BigDecimal getDepth() {
        return depth;
    }

    public void setDepth(BigDecimal depth) {
        this.depth = depth;
    }

    public BigDecimal getVolume() {
        return volume;
    }

    public void setVolume(BigDecimal volume) {
        this.volume = volume;
    }

    public long getWeight() {
        return weight;
    }

    public void setWeight(long weight) {
        this.weight = weight;
    }

    public boolean isMultiplePart() {
        return multiplePart;
    }

    public void setMultiplePart(boolean multiplePart) {
        this.multiplePart = multiplePart;
    }

    public Integer getMultiplePartAmount() {
        return multiplePartAmount;
    }

    public void setMultiplePartAmount(Integer multiplePartAmount) {
        this.multiplePartAmount = multiplePartAmount;
    }

    public boolean isMeasured() {
        return measured;
    }

    public void setMeasured(boolean measured) {
        this.measured = measured;
    }

    public boolean isPreferOwnBox() {
        return preferOwnBox;
    }

    public void setPreferOwnBox(boolean preferOwnBox) {
        this.preferOwnBox = preferOwnBox;
    }

    public boolean isPreferBag() {
        return preferBag;
    }

    public void setPreferBag(boolean preferBag) {
        this.preferBag = preferBag;
    }

    public boolean isUseBubbleFilm() {
        return useBubbleFilm;
    }

    public void setUseBubbleFilm(boolean useBubbleFilm) {
        this.useBubbleFilm = useBubbleFilm;
    }

    public ItemGroup getItemGroup() {
        return itemGroup;
    }

    public void setItemGroup(ItemGroup itemGroup) {
        this.itemGroup = itemGroup;
    }

    public ItemUnit getItemUnit() {
        return itemUnit;
    }

    public void setItemUnit(ItemUnit itemUnit) {
        this.itemUnit = itemUnit;
    }
}