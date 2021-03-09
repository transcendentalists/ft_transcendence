export function drawText(ctx, text, x, y, font, color) {
  ctx.fillStyle = color;
  ctx.font = font;
  ctx.fillText(text, x, y);
}

export function drawMap(ctx, x, y, w, h, start_color, end_color) {
  let my_gradient = ctx.createLinearGradient(x, y, w, h);
  my_gradient.addColorStop(0, start_color);
  my_gradient.addColorStop(1, end_color);
  ctx.fillStyle = my_gradient;
  ctx.fillRect(x, y, w, h);
}

export function drawRect(ctx, x, y, w, h, color) {
  ctx.fillStyle = color;
  ctx.fillRect(x, y, w, h);
}

export function drawCircle(ctx, x, y, r, color, opacity = 1) {
  if (color == "BLACK") color = "rgba(0,0,0," + opacity;
  else if (color == "WHITE") color = "rgba(255,255,255," + opacity;
  else color = "rgba(" + color + "," + opacity + ")";
  ctx.fillStyle = color;
  ctx.beginPath();
  ctx.arc(x, y, r, 0, Math.PI * 2, false);
  ctx.fill();
}
