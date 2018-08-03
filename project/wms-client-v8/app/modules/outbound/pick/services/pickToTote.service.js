/** * Created by xiong on 2017/4/14. */(function () {    "use strict";    angular.module("myApp").service("pickToToteService",function ($http,$window,commonService,OUTBOUND_CONSTANT) {        return{            //扫描工作站            scanStation:function (stationName,succ,error) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.scanPickToToteStation+"?pickStationName="+ stationName,                    success:function (datas) {                        var info = datas.data.resultMessage;                        var result = {};                        if(info == 404){//工作站无效                            result={msg:"none"};                            succ(result);                        }                        if(info == 405){//工作站已被用户绑定                            result={msg:"user",obj:datas.data.operatorName};                            succ(result);                        }                        if(info == 406){//工作站绑定的有货筐                            result={msg:"storage",obj:datas.data};                            succ(result);                        }                        if(info == 1){//工作站扫描成功                            result={msg:"success",obj:datas.data};                            succ(result);                        }                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            getfinishOrder:function (stationId,success,error) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.getfinishOrder+"?stationId="+stationId,                    method:"GET",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //查看问题筐是否绑定            checkProStorage:function (stationName,succ) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.checkStorage +"?stationName="+stationName,                    success:function (datas) {                        var info = datas.data.resultMessage;                        if(info == 700){//没有绑定残品筐                            var result = {msg:"DAMAGED_PICKUNITLOAD_NOT_EXIST",data:datas.data};                            succ(result);                        }                        if(info == 701){//没有绑定无法扫描筐                            var result = {msg:"UNSCAN_PICKUNITLOAD_NOT_EXIST",data:datas.data};                            succ(result);                        }                        if(info == 1){                            var result = {msg:"SUCCESS"};                            succ(result);                        }                    }                })            },            //扫描pod，检查batch对应的货筐是否绑定            checkBatch:function (podName,stationName,success,error) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.checkOrder+"?podName="+podName+"&stationName="+stationName,                    success:function (datas) {                        var info = datas.data.resultMessage;                        if(info == 702){//需要绑定货筐                            var result = {msg:"PICKUNITLOAD_NOT_EXIST",data:datas.data};                            success(result);                        }else if(info == 1){                            var result = {msg:"SUCCESS",data:datas.data};                            success(result);                        }else {                            var result = {data:datas.data};                            success(result);                        }                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描残品筐            scanCanPinBasket:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.bindStorage,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描灯标签获取灯的信息            scanDigitalName:function (positionNo,success,error) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.scanPosition+"?positionNo="+positionNo,                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描无法扫描货筐            scanUnScanSKUBasket:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.bindStorage,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描空拣货货筐            scanEmptyStorage:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.bindStorage,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描pod            scanPod:function (podName,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.findPod+'?podName='+podName,                    success:function (datas) {                        success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //获取orderposition            getOrderPosition:function (podName,stationName,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.getOrder+'?podName='+podName+"&stationName="+stationName,                    success:function (datas) {                        success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描商品            scanSKU:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.confirmItem,                    method:"POST",                    data:obj,                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //输入正品数量确认            confirmPickAmount:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.confirmAmount,                    method:"POST",                    data:obj,                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //输入残品数量确认            confirmDamagedAmount:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.confirmDamagedAmount,                    method:"POST",                    data:obj,                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描商品序列号            scanSeriesNo:function (pickId,serialNo,success) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.scanSerialNo+"?pickId="+pickId+"&serialNo="+serialNo,                    success:function (datas) {                        success("ok");                    }                })            },            //扫描残损商品            scanskuDamaged:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.scanDamagedItem,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //获取站台当前货筐的信息            getBakInfo:function (data,type,success) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.getAllstorageInfo + "?stationName="+data+"&type="+type,                    success: function (datas) {                        success(datas.data);                    }                });            },            //批次是否完成            checkOrder:function (stationName,success) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.checkOrderFinish + "?pickStationName="+stationName,                    success: function (datas) {                        success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                });            },            //扫描已满货筐            scanfullBasket:function (storagename,stationname,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.fullstorage + "?storageName="+storagename+"&pickStationName="+stationname,                    success: function (datas) {                        success(datas.data);                    },error:function (datas) {                        error&&error(datas.data);                    }                });            },            //扫描新的货筐            scanNewBasket:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.bindStorage,                    method:"POST",                    data:obj,                    success:function (datas) {                        success&&success(datas.data);                    },error:function (datas) {                        error&&error(datas.data);                    }                })            },            //扫描货位            scanHuoWei:function (binName,pickId,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.scanBin + "?binName="+binName+"&pickId="+pickId,                    success: function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                });            },            //逐一扫描货位的商品            scanEachSKU:function (obj,success,error) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.scanSKU,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //已扫描完所有商品            haveScanedAllSKU:function (obj,success) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.haveScanedAllItem,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    }                })            },            //结满工作站所有货筐            fullAllStorage:function (stationName,success) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.fullAllStorage+"?stationName="+stationName,                    success:function (datas) {                        success&&success(datas.data);                    }                })            },            //绑定货筐            bindStorage:function (obj,success) {                commonService.ajaxMushiny({                    url: OUTBOUND_CONSTANT.bindStorageWithItem,                    data:obj,                    method:"POST",                    success:function (datas) {                        success&&success(datas.data);                    }                })            },            //停止工作            stopWorking:function (stationName,success,error) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.stopWorking+"?stationName="+stationName,                    success:function (datas) {                        success&&success(datas.data);                    },                    error:function (datas) {                        error&&error(datas.data);                    }                })            },            //调用问题处理接口            callObProblem:function (data) {                commonService.ajaxMushiny({                    url:OUTBOUND_CONSTANT.obproblem,                    data:data,                })            },            //打开电子标签            openLight:function (data) {                $http({                    url:"http://192.168.1.92:9090/light/onOff?labelId="+data+"&onOffFlag=true",                    method:"GET",                    headers: {                        "Content-Type": options.contentType || "application/json;charset=utf-8",                        "Warehouse": $window.localStorage["warehouseId"],                        "Authorization": "Bearer "+ $window.localStorage["accessToken"]                    },                })            },            //控制颜色打开灯            openLightWithColor:function (data,color) {                $http({                    url:"http://192.168.1.88:9090/light/onOffColor?labelId="+data+"&onOffFlag=true&color="+color,                })            },            //改变灯的颜色            changeLightColor:function (labelId,color) {                $http({                    url:"http://192.168.1.88:9090/light/changeTagColor?labelId="+labelId+"&color="+color,                })            },        }    });})();