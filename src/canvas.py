from __future__ import annotations

import logging
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw

from constants import IMAGES_DIR

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Point:
    x: float
    y: float


class Renderer:
    """Minimal Pillow-backed renderer that always saves under IMAGES_DIR."""

    def __init__(self, width: int, height: int, bg: str = "white") -> None:
        logger.debug("init Renderer width=%s height=%s bg=%s", width, height, bg)
        self.img = Image.new("RGBA", (width, height), bg)
        self.draw = ImageDraw.Draw(self.img)

    def circle(
        self,
        center: Point,
        r: float,
        *,
        fill: str = "black",
        outline: str | None = None,
        width: int = 1,
    ) -> None:
        bbox = (center.x - r, center.y - r, center.x + r, center.y + r)
        logger.debug(
            "circle cx=%s cy=%s r=%s fill=%s outline=%s width=%s bbox=%s",
            center.x,
            center.y,
            r,
            fill,
            outline,
            width,
            bbox,
        )
        self.draw.ellipse(bbox, fill=fill, outline=outline, width=width)

    def savePNG(self, name: str | Path) -> Path:
        """Save the image into IMAGES_DIR. Adds .png if no suffix is given."""

        out = IMAGES_DIR.joinpath(name if Path(name).suffix else Path(f"{name}.png"))
        out.parent.mkdir(parents=True, exist_ok=True)
        logger.info("saving image to %s size=%s", out, self.img.size)
        self.img.save(out)

        return out


if __name__ == "__main__":
    r = Renderer(400, 300, bg="white")
    r.circle(Point(200, 150), 60, fill="red", outline="black", width=3)
    path = r.savePNG("example_circle.png")
    print("saved to:", path)
