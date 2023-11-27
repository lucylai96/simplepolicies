% scratchpad
load models5
load pilot1
simdata = sim_fitted('nocost', data, results);
plot_figures('exp1v3',simdata)

for m = 1:7
    for s = 1:30
        for i = 1:length(results(m).latents(s).lik)
            tmp1(i) = results(m).K*log(data(s).N/length(data(s).exp)) - 2*results(m).latents(s).lik(i);
            tmp2(i) = results(m).K*2 - 2*results(m).latents(s).lik(i);
        end
       bic(s,m) = sum(tmp1);
        aic(s,m) = sum(tmp2);
    end
end