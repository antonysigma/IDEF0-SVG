import subprocess as p

import uvicorn
from fastapi import FastAPI, Response

from plantuml_decoder import plantuml_decode
from parser import grammar, IdefVisitor

app = FastAPI()


@app.get(
    "/svg/{base64_data}",
    responses={200: {"content": {"image/svg+xml": {}}}},
    response_class=Response,
)
def render(base64_data: str):
    decoded = plantuml_decode(base64_data)
    tree = grammar.parse(decoded.lstrip())
    iv = IdefVisitor()
    parsed = iv.visit(tree)

    process = p.Popen("./bin/schematic", stdin=p.PIPE, stdout=p.PIPE)
    svg_data: bytes = process.communicate(parsed.encode("utf-8"))[0]

    return Response(content=svg_data, media_type="image/svg+xml")


if __name__ == "__main__":
    uvicorn.run("webapp:app")
