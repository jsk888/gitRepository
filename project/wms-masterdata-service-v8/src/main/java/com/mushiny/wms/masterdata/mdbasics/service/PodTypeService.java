package com.mushiny.wms.masterdata.mdbasics.service;

import com.mushiny.wms.common.service.BaseService;
import com.mushiny.wms.masterdata.mdbasics.crud.dto.PodTypeDTO;

import java.util.List;

public interface PodTypeService extends BaseService<PodTypeDTO> {

    List<PodTypeDTO> getAll();
}
