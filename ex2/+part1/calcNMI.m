function nmi = calcNMI ( A, B )
% CALCNMI calculate the NMI of A and B
%   NMI(A,B) = (H(A)+H(B))/H(A,B) -> using histcounts2


    % TODO: turn -inf to 0
    [h_ab, a_bounds, b_bounds] = histcounts2(A,B);
    log_h_ab = log2(h_ab);
    h_ab(h_ab == -Inf) = 0; log_h_ab(log_h_ab == -Inf) = 0;
    i_ab = -sum(sum(h_ab .* log_h_ab));
    [h_a, ~] = histcounts(A, a_bounds);
    log_h_a = log2(h_a);
    h_a(h_a == -Inf) = 0; log_h_a(log_h_a == -Inf) = 0;
    i_a = -sum(sum(h_a .* log_h_a));
    [h_b, ~] = histcounts(B, b_bounds);
    log_h_b = log2(h_b);
    h_b(h_b == -Inf) = 0; log_h_b(log_h_b == -Inf) = 0;
    i_b = -sum(sum(h_b .* log_h_b));
    
    nmi = (i_a + i_b)/i_ab;

end