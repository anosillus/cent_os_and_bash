FROM krallin/centos-tini:centos7
LABEL author="anosillus"
USER root

# yum install {{{
RUN yum update -y \
  && yum install -y\
      bzip2 \
      ca-certificates \
      curl \
      dpkg \
      fonts-liberation \
      git \
      grep \
      locales \
      mercurial \
      sed \
      subversion \
      sudo \
      wget \
      zsh \
      ipa-gothic-fonts \
      ipa-mincho-fonts \
      ipa-pgothic-fonts \
      ipa-pmincho-fonts \
    && yum clean all
# }}}

# [Docker 日本語環境構築まとめ 2 - Qiita](https://qiita.com/kkbt/items/333719512bb8598cbf39) {{{
# 言語を日本語に設定
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# 日付を日本語に設定
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# manをインストールする前に、manファイルをインストールするように設定変更
RUN sed -i -e"s/^tsflags=nodocs/\# tsflags=nodocs/" /etc/yum.conf

# manと、man-pagesをインストール
RUN yum -y install man man-pages.noarch man-pages-ja.noarch
# }}}

# conda install {{{
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash

ENV PATH=$CONDA_DIR/bin:$PATH
ENV HOME=/home/
WORKDIR $HOME

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -f -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    # conda build purge-all && \
    rm -rf /home/.cache/yarn
# }}}

# jupyter setting {{{
RUN mkdir -p /home/.jupyter && { \
    echo "c.NotebookApp.allow_root = True"; \
    echo "c.NotebookApp.ip = '0.0.0.0'"; \
    echo "c.NotebookApp.token = ''"; \
    echo "c.JupyterLabTemplates.include_default = True"; \
    } | tee /home/.jupyter/jupyter_notebook_config.py

RUN conda install -c conda-forge jupyterlab bash_kernel nodejs ipywidgets && \
    jupyter lab build && \
    conda clean -tipsy && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf /home/.cache/yarn && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/.node-gyp && \
    rm -rf /home/.local
# }}}

# server start command {{{
SHELL ["/bin/bash", "-c"]
ENV BASH_ENV /home/.bashrc

RUN mkdir /home/playground
VOLUME /home/playground

EXPOSE 8888
ENTRYPOINT [ "/usr/bin/tini", "--" ]
# }}}
