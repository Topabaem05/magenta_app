import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RepositoryTests(unittest.TestCase):
    def run_script(self, name: str) -> None:
        result = subprocess.run(
            [sys.executable, str(ROOT / "scripts" / name)],
            cwd=ROOT,
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_scaffold(self) -> None:
        self.run_script("check_scaffold.py")

    def test_repository(self) -> None:
        self.run_script("check_repository.py")


if __name__ == "__main__":
    unittest.main()
