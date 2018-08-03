package com.mushiny.wms.report.domain;

import com.mushiny.wms.common.entity.BaseClientAssignedEntity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "OB_CUSTOMERSHIPMENTPOSITION")
public class CustomerShipmentPosition extends BaseClientAssignedEntity {
    private static final long serialVersionUID = 1L;

    @Column(name = "AMOUNT", nullable = false)
    private BigDecimal amount;

    @Column(name = "AMOUNT_PICKED", nullable = false)
    private BigDecimal amountPicked = BigDecimal.ZERO;

    @Column(name = "AMOUNT_REBINED", nullable = false)
    private BigDecimal amountRebined = BigDecimal.ZERO;

    @Column(name = "ORDER_INDEX", nullable = false)
    private int orderIndex;

    @Column(name = "POSITION_NO", nullable = false)
    private int positionNo;

    @Column(name = "STATE", nullable = false)
    private int state;

    @ManyToOne(optional = false)
    @JoinColumn(name = "ITEMDATA_ID")
    private ItemData itemData;

    @ManyToOne(optional = false)
    @JoinColumn(name = "SHIPMENT_ID")
    private CustomerShipmentTest customerShipment;

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getAmountPicked() {
        return amountPicked;
    }

    public void setAmountPicked(BigDecimal amountPicked) {
        this.amountPicked = amountPicked;
    }

    public BigDecimal getAmountRebined() {
        return amountRebined;
    }

    public void setAmountRebined(BigDecimal amountRebined) {
        this.amountRebined = amountRebined;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public int getPositionNo() {
        return positionNo;
    }

    public void setPositionNo(int positionNo) {
        this.positionNo = positionNo;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public ItemData getItemData() {
        return itemData;
    }

    public void setItemData(ItemData itemData) {
        this.itemData = itemData;
    }

    public CustomerShipmentTest getCustomerShipment() {
        return customerShipment;
    }

    public void setCustomerShipment(CustomerShipmentTest customerShipment) {
        this.customerShipment = customerShipment;
    }
}
