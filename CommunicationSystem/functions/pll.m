function output = pll(input, Nsam, alpha, k)
N = length(input);
output = zeros(N, 1);
phaseError = 0;
phaseError_mean = 0;
for n=1:N
 output(n) = cos(2*pi*n/Nsam + phaseError * k);
 phaseError = output(n) * input(n);
 phaseError_mean = alpha * phaseError_mean + (1-alpha) * phaseError;
end
