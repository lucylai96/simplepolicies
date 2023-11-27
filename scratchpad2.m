%            1      2            3          4          5            6      7        8          9         10      11
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv','capacity_pg','value_pg','pg'};

% order: pg, capacity pg, value, value pg, cv, fixed, capacity, f6beta  (median)
% order: pg, value, value pg, capacity pg, cv, capacity, fixed, f6beta  (mean)

% maybe the relevant final models should be:
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity_pg','value_pg','pg','cv'};
models = {'rlwm','nocost','nc_multibeta','fixed','f_multibeta','capacity','value','cv'};

% no diff between the capacity and capacity_pg, value and value_pg
% fixed and pg are extremely similar (beta basically doesn't move in the pg model)

for m = 1:length(models)
    load([models{m} '.mat'])
    new_results(m) = results;
end

results = new_results;
bms_results = mfit_bms(results,1);

figure; hold on;
y = median([results.bic]);
y = y-min(y);
pxp = bms_results.pxp;
[~,idx] = sort(y);
cmap = brewermap(11,'Set1');

subplot 211; hold on; colororder(cmap)
for m = idx
    bar(find(m==idx),pxp(m),'FaceColor',cmap(find(m==idx),:));
end
ylabel('PXP'); ylim([0 1]);xticks(1:length(results));

subplot 212; hold on;
for m = idx
    bar(find(m==idx),y(m),'FaceColor',cmap(find(m==idx),:));
    errorbar(find(m==idx),y(m),sem(results(m).bic,1)/2,sem(results(m).bic,1)/2)
end
ylabel('\Delta BIC from best model'); %set(gca,'YScale', 'log');
ylim([0 30])
xticks(1:length(results)); xticklabels(models(idx))
text(0.3,10^25,'**Winning model','FontSize',20)

load data_final;

simdata_cv = sim_fitted('cv', data, results(8));
analyze_data('task1',simdata_cv,'dynamic');
analyze_data('task2',simdata_cv,'dynamic');
analyze_data('task3',simdata_cv,'dynamic');

analyze_data('task1',simdata_cv,'main');
analyze_data('task2',simdata_cv,'main');
analyze_data('task3',simdata_cv,'main');

analyze_data('task1',simdata_cv,'action_biases');
analyze_data('task2',simdata_cv,'action_biases');
analyze_data('task3',simdata_cv,'suboptimal');
analyze_data('task3',simdata_cv,'beta');

simdata_pg = sim_fitted('pg', data, results(11)); % x cant capture task 2 dynamics
analyze_data('task1',simdata_pg,'dynamic');
analyze_data('task2',simdata_pg,'dynamic');
analyze_data('task3',simdata_pg,'dynamic');

analyze_data('task1',simdata_pg,'action_biases');
analyze_data('task2',simdata_pg,'action_biases');
analyze_data('task3',simdata_pg,'suboptimal');

analyze_data('task2',simdata_pg,'main');
analyze_data('task3',simdata_pg,'main');
analyze_data('task1',simdata_pg,'beta');
analyze_data('task2',simdata_pg,'beta');
analyze_data('task3',simdata_pg,'beta');

simdata_f = sim_fitted('fixed', data, results(4)); % x cant capture task 2 dynamics
analyze_data('task1',simdata_f,'dynamic');
analyze_data('task2',simdata_f,'dynamic');
analyze_data('task3',simdata_f,'dynamic');

analyze_data('task2',simdata_f,'main');
analyze_data('task3',simdata_f,'main');
analyze_data('task3',simdata_f,'suboptimal');
analyze_data('task3',simdata_f,'beta');

simdata_v = sim_fitted('value', data, results(7)); % x cant capture task 3 or task 2 dynamics
analyze_data('task2',simdata_v,'main');
analyze_data('task2',simdata_v,'dynamic');
analyze_data('task3',simdata_v,'main');
analyze_data('task3',simdata_v,'dynamic');
analyze_data('task3',simdata_v,'suboptimal');

simdata_vpg = sim_fitted('value_pg', data, results(10)); % x cant capture task 3 or task 2 dynamics
analyze_data('task2',simdata_vpg,'main');
analyze_data('task2',simdata_vpg,'dynamic');
analyze_data('task3',simdata_vpg,'main');
analyze_data('task3',simdata_vpg,'dynamic');
analyze_data('task3',simdata_vpg,'suboptimal');
analyze_data('task3',simdata_vpg,'beta');

simdata_c = sim_fitted('capacity', data, results(6)); % x cant capture task 3 or task 2 dynamics
analyze_data('task2',simdata_c,'main');
analyze_data('task2',simdata_c,'dynamic');
analyze_data('task3',simdata_c,'main');
analyze_data('task3',simdata_c,'dynamic');
analyze_data('task3',simdata_c,'suboptimal');

simdata_cpg = sim_fitted('capacity_pg', data, results(9)); % x cant capture task 3 or task 2 dynamics
analyze_data('task2',simdata_cpg,'main');
analyze_data('task2',simdata_cpg,'dynamic');
analyze_data('task3',simdata_cpg,'main');
analyze_data('task3',simdata_cpg,'dynamic');
analyze_data('task3',simdata_cpg,'suboptimal');
analyze_data('task3',simdata_cpg,'beta');

simdata_fmb = sim_fitted('f_multibeta', data, results(5));
analyze_data('task3',simdata_fmb,'main');
analyze_data('task3',simdata_fmb,'dynamic');
analyze_data('task3',simdata_fmb,'suboptimal');
analyze_data('task3',simdata_fmb,'beta');

simdata_rlwm = sim_fitted('rlwm', data, results(1));
analyze_data('task3',simdata_rlwm,'main');
analyze_data('task3',simdata_rlwm,'dynamic');
analyze_data('task3',simdata_rlwm,'suboptimal');
analyze_data('task3',simdata_rlwm,'beta');

simdata_nc = sim_fitted('nc', data, results(2));
analyze_data('task1',simdata_nc,'dynamic');
analyze_data('task2',simdata_nc,'dynamic');
analyze_data('task3',simdata_nc,'dynamic');

simdata_ncmb = sim_fitted('nc_multibeta', data, results(3));

% data
analyze_data('task3',data,'main');
analyze_data('task3',data,'dynamic');
analyze_data('task3',data,'suboptimal');

analyze_data('task2',data,'optimizers');
v_sidx = [2   10   21   25   27   33   36   44   47   53   62   64   74   81   85   92   97   98  100  101  102  107  118  121  123  132  138  140  141  143  145  146  149  150  151  153  154  159  167  170  172  178  185  199  200];
c_sidx = [2    4    5   12   13   14   15   19   26   27   28   29   30   31   32   34   37   39   40   42   43   44   46   47   48   49   53   56   59   60   62   63   68   69   72   73   75   76   77   78   79   80   84   86   87   92   94   99  100  101  102  103  104  105  106  110  114  116  119  121  124  126  127  131  133  134  139  140  143  144  145  151  153  154  159  160  162  164  165  166  167  169  170  171  178  180  181  182  183  189  197  198  199];
analyze_data('task2',data,'dynamic',v_sidx);
analyze_data('task2',data,'dynamic',c_sidx);
analyze_data('task2',simdata_pg,'dynamic',v_sidx);


analyze_data('task1',data,'optimizers');

v_sidx = [3    4    6   17   21   24   30   31   36   37   39   44   49   62   64   74   80   83   84   85   87   88   92  102  105  106  108  114  116  121  123  125  129  131  143  145  153  154  156  159  160  161  162  169  172  177  183  186  187  188  194  196  198];

analyze_data('task1',data,'dynamic',v_sidx);







