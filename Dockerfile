FROM python:3.6-alpine

# install janome with NEologd dictionary
# https://github.com/mocobeta/janome/wiki/(very-experimental)-NEologd-%E8%BE%9E%E6%9B%B8%E3%82%92%E5%86%85%E5%8C%85%E3%81%97%E3%81%9F-janome-%E3%82%92%E3%83%93%E3%83%AB%E3%83%89%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
# https://drive.google.com/drive/folders/0BynvpNc_r0kSd2NOLU01TG5MWnc
RUN apk add --no-cache --virtual .builddeps curl && \
    FILE_ID=14CK0rkep2nvVpfGCJu_QQFf2PUkcI6BN && \
    FILE_NAME=/tmp/Janome-0.3.6.neologd-20180409.tar.gz && \
    COOKIE=/tmp/cookie && \
    curl -sc $COOKIE "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null && \
    CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)" && \
    curl -Lb $COOKIE "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o ${FILE_NAME}  && \
    pip install ${FILE_NAME} --no-compile && \
    python -c "from janome.tokenizer import Tokenizer; Tokenizer(mmap=True)" && \
    rm ${FILE_NAME} $COOKIE && \
    apk del .builddeps

CMD ["python3"]
