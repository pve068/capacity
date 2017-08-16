source("batch_tune_otb_materialization.R")

# TODO: add segmentation columns here
dep.var <- "final_status_code"
indep.vars <- c("TRADE_DSC", "BB_CUST_SEGMENT")
model.type <- c("logistic")  # only logistic for now

fits <- BatchTuneOTBMaterialization(dep.var = dep.var, 
                                    indep.vars = indep.vars,
                                    model.type = model.type)