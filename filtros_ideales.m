% =========================================================================
% Pregunta 4: Análisis en frecuencia de filtros ideales
% Filtro pasabajos, pasabanda y pasaaltos ideales
% =========================================================================

clear all; close all; clc;

%% Parámetros generales
wc = 2*pi*1000;  % Frecuencia de corte: 1000 rad/s
w1 = 2*pi*500;   % Frecuencia inferior pasabanda: 500 rad/s
w2 = 2*pi*1500;  % Frecuencia superior pasabanda: 1500 rad/s

% Vector de tiempo para respuestas
t = linspace(-0.01, 0.01, 10000);
t_step = linspace(0, 0.01, 5000);

%% ========================================================================
%  FILTRO PASABAJOS IDEAL
%  ========================================================================
fprintf('=== FILTRO PASABAJOS IDEAL ===\n');

% Respuesta impulsiva: h(t) = (wc/pi) * sinc(wc*t/pi)
h_lpf = (wc/pi) * sinc(wc*t/pi);

% Respuesta al paso: integral de h(t)
step_lpf = zeros(size(t_step));
for i = 1:length(t_step)
    step_lpf(i) = integral(@(tau) (wc/pi) * sinc(wc*tau/pi), 0, t_step(i));
end

% Gráficas
figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t*1000, h_lpf, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('h(t)');
title('Respuesta Impulsiva - Filtro Pasabajos Ideal');
xlim([-10 10]);

subplot(1,2,2);
plot(t_step*1000, step_lpf, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('Respuesta al paso');
title('Respuesta al Paso - Filtro Pasabajos Ideal');

saveas(gcf, 'filtro_pasabajos_ideal.png');

%% ========================================================================
%  FILTRO PASABANDA IDEAL
%  ========================================================================
fprintf('=== FILTRO PASABANDA IDEAL ===\n');

% Respuesta impulsiva: h(t) = (2/pi) * [sin(w2*t) - sin(w1*t)] / t
% Usando sinc normalizado: sinc(x) = sin(pi*x)/(pi*x)
h_bpf = (w2/pi) * sinc(w2*t/pi) - (w1/pi) * sinc(w1*t/pi);

% Respuesta al paso
step_bpf = zeros(size(t_step));
for i = 1:length(t_step)
    step_bpf(i) = integral(@(tau) (w2/pi) * sinc(w2*tau/pi) - (w1/pi) * sinc(w1*tau/pi), 0, t_step(i));
end

% Gráficas
figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t*1000, h_bpf, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('h(t)');
title('Respuesta Impulsiva - Filtro Pasabanda Ideal');
xlim([-10 10]);

subplot(1,2,2);
plot(t_step*1000, step_bpf, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('Respuesta al paso');
title('Respuesta al Paso - Filtro Pasabanda Ideal');

saveas(gcf, 'filtro_pasabanda_ideal.png');

%% ========================================================================
%  FILTRO PASAALTOS IDEAL
%  ========================================================================
fprintf('=== FILTRO PASAALTOS IDEAL ===\n');

% Respuesta impulsiva: h(t) = δ(t) - (wc/pi) * sinc(wc*t/pi)
% Aproximación numérica del delta
delta_approx = zeros(size(t));
[~, idx_zero] = min(abs(t));
delta_approx(idx_zero) = 1000;  % Aproximación del impulso

h_hpf = delta_approx - (wc/pi) * sinc(wc*t/pi);

% Respuesta al paso: u(t) - integral de h_lpf(t)
step_hpf = zeros(size(t_step));
for i = 1:length(t_step)
    step_hpf(i) = 1 - integral(@(tau) (wc/pi) * sinc(wc*tau/pi), 0, t_step(i));
end

% Gráficas
figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t*1000, h_hpf, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('h(t)');
title('Respuesta Impulsiva - Filtro Pasaaltos Ideal');
xlim([-10 10]);
ylim([-100 1200]);

subplot(1,2,2);
plot(t_step*1000, step_hpf, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('Respuesta al paso');
title('Respuesta al Paso - Filtro Pasaaltos Ideal');

saveas(gcf, 'filtro_pasaaltos_ideal.png');

fprintf('\nGráficas guardadas exitosamente.\n');
