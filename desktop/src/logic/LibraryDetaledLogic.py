import json
from datetime import datetime, timedelta

import requests
from PySide6.QtCore import QObject, Signal, Slot, Property

from desktop.src.services.AuthService import AuthService
from desktop.src.settings import LIBRARY_URL


class LibraryDetailedLogic(QObject):
    game_title_changed = Signal()
    is_game_installed_changed = Signal()
    last_launched_changed = Signal()
    play_time_changed = Signal()

    def __init__(self, auth_service: AuthService):
        super().__init__()

        self._auth_service = auth_service

        self._game_title = ''
        self._is_game_installed = False
        self._last_launched = False
        self._play_time = ''

    # region Game title

    @Property(str, notify=game_title_changed)
    def game_title(self):
        return self._game_title

    @game_title.setter
    def game_title(self, new_value: str):
        if self._game_title != new_value:
            self._game_title = new_value
            self.game_title_changed.emit()

    # endregion

    # region Is game installed

    @Property(bool, notify=is_game_installed_changed)
    def is_game_installed(self):
        return self._is_game_installed

    @is_game_installed.setter
    def is_game_installed(self, new_value: bool):
        if self._is_game_installed != new_value:
            self._is_game_installed = new_value
            self.is_game_installed_changed.emit()

    # endregion

    # region Last launched

    @Property(str, notify=last_launched_changed)
    def last_launched(self):
        return self._last_launched

    @last_launched.setter
    def last_launched(self, new_value: str):
        if self._last_launched != new_value:
            self._last_launched = new_value
            self.last_launched_changed.emit()

    # endregion

    # region Last launched

    @Property(str, notify=play_time_changed)
    def play_time(self):
        return self._play_time

    @play_time.setter
    def play_time(self, new_value: str):
        if self._play_time != new_value:
            self._play_time = new_value
            self.play_time_changed.emit()

    # endregion

    def _check_game_installed(self, game_id: int) -> bool:
        with open("../app_config.json", "r") as app_config_file:
            config = json.load(app_config_file)['config']
            for app in config["apps"]:
                if game_id == app['id']:
                    return True
            return False

    @Slot(int)
    def load(self, game_id: int):
        headers = {"Authorization": self._auth_service.session_id}
        current_user_id = self._auth_service.current_user["id"]

        reply = requests.get(LIBRARY_URL + f"?user_id={current_user_id}&game_id={game_id}", headers=headers)
        if reply.status_code == requests.codes.ok:
            data = reply.json()[0]

            self.game_title = data["game"]["title"]

            self.is_game_installed = self._check_game_installed(data["game"]["id"])

            game_play_time = data["game_time"]
            if game_play_time / 3600 < 1:
                self.play_time = '{00:.0f}'.format(game_play_time // 60)
            else:
                self.play_time = '{0:.1f}'.format(game_play_time / 3600)

            possible_last_launch_stamp: int | None = data["last_run"]
            if possible_last_launch_stamp:
                launch_date = datetime.fromtimestamp(possible_last_launch_stamp)

                if datetime.today().date() == launch_date.date():
                    self.last_launched = "Today"
                elif datetime.today().date() - timedelta(1) == launch_date.date():
                    self.last_launched = "Yesterday"
                else:
                    self.last_launched = launch_date.strftime('%d %b %y')
            else:
                self.last_launched = "Never"

    @Slot()
    def download(self):
        pass

    @Slot()
    def run(self):
        pass
