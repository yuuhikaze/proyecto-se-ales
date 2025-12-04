% =========================================================================
% Pregunta 5: Filtro pasabajos de primer orden para filtrar señal a 60Hz
% =========================================================================

clear all; close all; clc;

%% Especificaciones del filtro
f_señal = 60;                    % Frecuencia a filtrar: 60 Hz
w_señal = 2*pi*f_señal;          % Frecuencia angular: 377 rad/s

% Seleccionamos frecuencia de corte una década debajo de 60Hz
fc = 6;                          % Frecuencia de corte: 6 Hz
wc = 2*pi*fc;                    % Frecuencia angular de corte

fprintf('=== FILTRO PASABAJOS DE PRIMER ORDEN ===\n');
fprintf('Frecuencia de corte: %.2f Hz (%.2f rad/s)\n', fc, wc);
fprintf('Frecuencia a atenuar: %.2f Hz (%.2f rad/s)\n\n', f_señal, w_señal);

%% Función de transferencia H(s) = wc / (s + wc)
num = [wc];
den = [1 wc];
H = tf(num, den);

fprintf('Función de transferencia:\n');
display(H);

%% Respuesta en frecuencia H(jω)
w = logspace(-1, 3, 1000);
[mag, phase] = bode(H, w);
mag = squeeze(mag);
phase = squeeze(phase);

% Convertir magnitud a dB
mag_dB = 20*log10(mag);

fprintf('Atenuación a 60 Hz: %.2f dB\n', mag_dB(find(w >= w_señal, 1)));

%% Respuesta impulsiva h(t) = wc * exp(-wc*t) * u(t)
t = linspace(0, 2, 1000);
h_t = wc * exp(-wc*t);

fprintf('\nRespuesta impulsiva:\n');
fprintf('h(t) = %.2f * exp(-%.2f*t) * u(t)\n', wc, wc);

%% Respuesta al paso: s(t) = [1 - exp(-wc*t)] * u(t)
s_t = 1 - exp(-wc*t);

fprintf('\nRespuesta al paso:\n');
fprintf('s(t) = [1 - exp(-%.2f*t)] * u(t)\n', wc);

%% Diagrama de Bode
figure('Position', [100, 100, 1200, 500]);

subplot(2,1,1);
semilogx(w/(2*pi), mag_dB, 'b', 'LineWidth', 1.5);
hold on;
semilogx([fc fc], [-80 10], 'r--', 'LineWidth', 1);
semilogx([f_señal f_señal], [-80 10], 'g--', 'LineWidth', 1);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud');
legend('|H(j\omega)|', sprintf('fc = %.1f Hz', fc), sprintf('f_{señal} = %.1f Hz', f_señal));
ylim([-80 10]);

subplot(2,1,2);
semilogx(w/(2*pi), phase, 'b', 'LineWidth', 1.5);
hold on;
semilogx([fc fc], [-100 10], 'r--', 'LineWidth', 1);
semilogx([f_señal f_señal], [-100 10], 'g--', 'LineWidth', 1);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (grados)');
title('Diagrama de Bode - Fase');
legend('\angle H(j\omega)', sprintf('fc = %.1f Hz', fc), sprintf('f_{señal} = %.1f Hz', f_señal));
ylim([-100 10]);

saveas(gcf, 'bode_primer_orden_60Hz.png');

%% Respuestas en el tiempo
figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t, h_t, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (s)');
ylabel('h(t)');
title('Respuesta Impulsiva');

subplot(1,2,2);
plot(t, s_t, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (s)');
ylabel('s(t)');
title('Respuesta al Paso');

saveas(gcf, 'respuestas_tiempo_primer_orden_60Hz.png');

%% Diagrama de polos y ceros
figure('Position', [100, 100, 600, 500]);
pzmap(H);
grid on;
title('Diagrama de Polos y Ceros');
saveas(gcf, 'polos_ceros_primer_orden.png');

%% Análisis de estabilidad
polos = pole(H);
fprintf('\n=== ANÁLISIS DE ESTABILIDAD ===\n');
fprintf('Polo del sistema: s = %.4f\n', polos);
fprintf('Parte real del polo: %.4f\n', real(polos));
if real(polos) < 0
    fprintf('Sistema ESTABLE (polo en semiplano izquierdo)\n');
else
    fprintf('Sistema INESTABLE\n');
end
fprintf('Sistema CAUSAL (filtro realizable físicamente)\n');

fprintf('\n=== EQUIVALENCIAS ===\n');
fprintf('Sistema eléctrico RC:\n');
fprintf('  - Constante de tiempo τ = RC = 1/wc = %.4f s\n', 1/wc);
fprintf('  - Si C = 10 µF, entonces R = %.2f kΩ\n', 1/(wc*10e-6)/1000);
fprintf('\nSistema mecánico masa-amortiguador:\n');
fprintf('  - Ecuación: M*dx/dt + B*x = B*u(t)\n');
fprintf('  - Con B/M = wc = %.2f rad/s\n', wc);

fprintf('\nArchivos generados exitosamente.\n');
