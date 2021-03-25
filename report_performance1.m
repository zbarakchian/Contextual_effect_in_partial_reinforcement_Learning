function [pmean pstd] = report_performance1(config_analysis,sbjs)

info_learning = config_analysis.info_learning;

perf  = info_learning.performance;

pmean = nanmean(perf(sbjs.indx));
pstd  = nanstd(perf(sbjs.indx));

disp([pmean pstd]);


