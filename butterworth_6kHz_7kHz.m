% =========================================================================
% Pregunta 9: Diseño de filtro pasabajos análogo Butterworth
% Especificaciones: fp = 6 kHz, fs = 7 kHz, Rp = 1.5 dB, As = 18 dB
% =========================================================================

clear all; close all; clc;

%% Especificaciones del filtro
fp = 6000;                       % Frecuencia de paso: 6 kHz
fs = 7000;                       % Frecuencia de supresión: 7 kHz
Rp = 1.5;                        % Rizado en banda de paso: 1.5 dB
As = 18;                         % Atenuación en banda de supresión: 18 dB

wp = 2*pi*fp;                    % Frecuencia angular de paso
ws = 2*pi*fs;                    % Frecuencia angular de supresión

fprintf('=== DISEÑO DE FILTRO BUTTERWORTH ===\n');
fprintf('Especificaciones:\n');
fprintf('  fp = %.1f kHz  (wp = %.2f rad/s)\n', fp/1000, wp);
fprintf('  fs = %.1f kHz  (ws = %.2f rad/s)\n', fs/1000, ws);
fprintf('  Rp = %.1f dB\n', Rp);
fprintf('  As = %.1f dB\n\n', As);

%% a) Cálculo del orden del filtro
% Fórmula: N = ceil(log10((10^(As/10) - 1)/(10^(Rp/10) - 1)) / (2*log10(ws/wp)))

numerador = log10((10^(As/10) - 1)/(10^(Rp/10) - 1));
denominador = 2*log10(ws/wp);
N_exacto = numerador / denominador;
N = ceil(N_exacto);

fprintf('=== a) ORDEN DEL FILTRO ===\n');
fprintf('Cálculo del orden:\n');
fprintf('  N = ceil(log10((10^(As/10)-1)/(10^(Rp/10)-1)) / (2*log10(ws/wp)))\n');
fprintf('  N_exacto = %.4f\n', N_exacto);
fprintf('  N = %d (orden del filtro)\n\n', N);

%% Frecuencia de corte del filtro Butterworth
% wc se calcula para cumplir exactamente la especificación en la banda de paso
wc = wp / ((10^(Rp/10) - 1)^(1/(2*N)));
fc = wc / (2*pi);

fprintf('Frecuencia de corte (-3dB):\n');
fprintf('  wc = %.2f rad/s\n', wc);
fprintf('  fc = %.2f Hz\n\n', fc);

%% b) Función de transferencia H(s)
fprintf('=== b) FUNCIÓN DE TRANSFERENCIA ===\n');

% Diseño usando Signal Processing Toolbox
[z, p, k] = buttap(N);           % Prototipo pasabajos normalizado
[num, den] = zp2tf(z, p, k);     % Conversión a función de transferencia

% Desnormalización (escalado en frecuencia)
[num_scaled, den_scaled] = lp2lp(num, den, wc);

% Crear función de transferencia
H = tf(num_scaled, den_scaled);

fprintf('Función de transferencia H(s):\n');
display(H);

% Polos y ceros
polos = pole(H);
ceros = zero(H);

fprintf('\nPolos del sistema:\n');
for i = 1:length(polos)
    fprintf('  p%d = %.4f %+.4fi  (|p| = %.4f, ∠ = %.2f°)\n', ...
            i, real(polos(i)), imag(polos(i)), abs(polos(i)), angle(polos(i))*180/pi);
end

fprintf('\nCeros del sistema:\n');
if isempty(ceros)
    fprintf('  No hay ceros finitos (todos en infinito)\n');
else
    for i = 1:length(ceros)
        fprintf('  z%d = %.4f %+.4fi\n', i, real(ceros(i)), imag(ceros(i)));
    end
end

%% Análisis de estabilidad y causalidad
fprintf('\n=== ANÁLISIS DE ESTABILIDAD Y CAUSALIDAD ===\n');
fprintf('Verificación de estabilidad:\n');
estable = all(real(polos) < 0);
if estable
    fprintf('  ✓ Todos los polos tienen parte real negativa\n');
    fprintf('  ✓ Sistema ESTABLE\n');
else
    fprintf('  ✗ Sistema INESTABLE\n');
end

fprintf('\nVerificación de causalidad:\n');
fprintf('  ✓ Grado del numerador (%d) ≤ grado del denominador (%d)\n', ...
        length(ceros), length(polos));
fprintf('  ✓ Sistema CAUSAL\n');

%% c) Respuesta en frecuencia - Diagrama de Bode
fprintf('\n=== c) RESPUESTA EN FRECUENCIA ===\n');

w = logspace(3, 5, 1000);
[mag, phase] = bode(H, w);
mag = squeeze(mag);
phase = squeeze(phase);
mag_dB = 20*log10(mag);

% Verificar especificaciones
mag_fp = interp1(w, mag_dB, wp);
mag_fs = interp1(w, mag_dB, ws);

fprintf('Verificación de especificaciones:\n');
fprintf('  Magnitud en fp (%.1f kHz): %.4f dB  (debe ser ≥ %.1f dB)\n', ...
        fp/1000, mag_fp, -Rp);
fprintf('  Magnitud en fs (%.1f kHz): %.4f dB  (debe ser ≤ %.1f dB)\n', ...
        fs/1000, mag_fs, -As);

if mag_fp >= -Rp
    fprintf('  ✓ Cumple especificación en banda de paso\n');
else
    fprintf('  ✗ No cumple especificación en banda de paso\n');
end

if mag_fs <= -As
    fprintf('  ✓ Cumple especificación en banda de supresión\n');
else
    fprintf('  ✗ No cumple especificación en banda de supresión\n');
end

%% Diagramas de Bode
figure('Position', [100, 100, 1200, 600]);

subplot(2,1,1);
semilogx(w/(2*pi), mag_dB, 'b', 'LineWidth', 2);
hold on;
% Líneas de especificación
semilogx([fp fp], [-100 5], 'g--', 'LineWidth', 1.5);
semilogx([fs fs], [-100 5], 'r--', 'LineWidth', 1.5);
semilogx([1000 1e5], [-Rp -Rp], 'g:', 'LineWidth', 1);
semilogx([1000 1e5], [-As -As], 'r:', 'LineWidth', 1);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title(sprintf('Diagrama de Bode - Magnitud (Butterworth orden %d)', N));
legend('|H(j\omega)|', sprintf('fp = %.1f kHz', fp/1000), ...
       sprintf('fs = %.1f kHz', fs/1000), sprintf('Rp = %.1f dB', Rp), ...
       sprintf('As = %.1f dB', As), 'Location', 'southwest');
xlim([1000 1e5]);
ylim([-100 5]);

subplot(2,1,2);
semilogx(w/(2*pi), phase, 'b', 'LineWidth', 2);
hold on;
semilogx([fp fp], [-450 10], 'g--', 'LineWidth', 1.5);
semilogx([fs fs], [-450 10], 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (grados)');
title('Diagrama de Bode - Fase');
legend('\angle H(j\omega)', sprintf('fp = %.1f kHz', fp/1000), ...
       sprintf('fs = %.1f kHz', fs/1000), 'Location', 'southwest');
xlim([1000 1e5]);
ylim([-450 10]);

saveas(gcf, 'bode_butterworth_6kHz_7kHz.png');

%% Diagrama de polos y ceros
figure('Position', [100, 100, 600, 600]);
pzmap(H);
grid on;
title(sprintf('Diagrama de Polos y Ceros - Butterworth orden %d', N));
saveas(gcf, 'polos_ceros_butterworth_6kHz_7kHz.png');

%% Respuesta impulsiva y al paso
t = linspace(0, 0.005, 5000);
h_t = impulse(H, t);
s_t = step(H, t);

figure('Position', [100, 100, 1200, 400]);

subplot(1,2,1);
plot(t*1000, h_t, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('h(t)');
title('Respuesta Impulsiva');

subplot(1,2,2);
plot(t*1000, s_t, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('s(t)');
title('Respuesta al Paso');

saveas(gcf, 'respuestas_tiempo_butterworth_6kHz_7kHz.png');

%% Comparación de selectividad
fprintf('\n=== ANÁLISIS DE SELECTIVIDAD ===\n');
fprintf('Banda de transición: %.1f kHz\n', (fs-fp)/1000);
fprintf('Factor de selectividad: %.4f\n', fs/fp);
fprintf('Nota: Banda de transición estrecha requiere orden alto (%d)\n', N);

fprintf('\nArchivos generados exitosamente.\n');
